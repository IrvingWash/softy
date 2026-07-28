#placeholder DEBUG;

#import "Basic"()(
    MEMORY_DEBUGGER                 = DEBUG,
    TEMP_ALLOCATOR_OVERWRITE_MEMORY = DEBUG,
);

#import "Sort";
Math :: #import "Math";

#import "SDL";

Display  :: #import,file "display.jai";
My_Math  :: #import,file "my_math.jai";
Triangle :: #import,file "triangle.jai";
Mesh     :: #import,file "mesh.jai";
Obj      :: #import,file "obj_parser.jai";
Texture  :: #import,file "texture.jai";
Clipping :: #import,file "clipping.jai";

#load "light.jai";
#load "camera.jai";

State :: struct {
    previous_frame_time_millis: float64;
    is_running: bool;

    polygon_mode:   Polygon_Mode;
    cull_backfaces: Cull_Mode;

    projection_matrix: My_Math.Matrix4;
    view_matrix:       My_Math.Matrix4;

    camera: Camera;
    camera.position = { 0, 0, -5 };

    mesh:         Mesh.Mesh;
    mesh_texture: Texture.Texture;

    sun:    Directional_Light;

    triangles_to_render: [..]Triangle.Triangle;
}

// @Todo: Change this to enum_flags
Polygon_Mode :: enum {
    WIREFRAME_AND_VERTICES;
    WIREFRAME;
    FACES;
    FACES_AND_WIREFRAME;
    TEXTURE;
    TEXTURE_AND_WIREFRAME;
}

Cull_Mode :: enum {
    BACKFACES;
    NONE;
}

FPS: float : 60;
FRAME_TARGET_TIME_MILLIS: float : 1000.0 / FPS;

state: State;

main :: () {
    #if DEBUG {
        defer report_memory_leaks();
    }

    setup_formatting();

    Display.init();
    defer Display.deinit();

    setup();
    defer destroy();

    while state.is_running {
        process_input();
        update();
        render();

        reset_temporary_storage();
    }
}

setup :: () {
    state.is_running = true;

    state.projection_matrix = My_Math.make_perspective_projection_matrix(
        cast(float, Display.window_height) / cast(float, Display.window_width),
        state.camera.fov,
        0.1,
        100,
    );

    obj := Obj.parse("assets/crab.obj");
    defer Obj.destroy(*obj);
    state.mesh = Mesh.create_mesh(obj.vertices, obj.faces);

    state.mesh_texture = Texture.load("assets/crab.png", flip = true);
}

destroy :: () {
    array_free(state.triangles_to_render);

    Texture.destroy(*state.mesh_texture);
    Mesh.destroy_mesh(*state.mesh);
}

process_input :: () {
    event: SDL_Event;
    SDL_PollEvent(*event);

    if event.type == {
        case .SDL_KEYDOWN;
            if event.key.keysym.sym == {
                case SDLK_ESCAPE;
                    state.is_running = false;
                case SDLK_1;
                    state.polygon_mode = .WIREFRAME_AND_VERTICES;
                case SDLK_2;
                    state.polygon_mode = .WIREFRAME;
                case SDLK_3;
                    state.polygon_mode = .FACES;
                case SDLK_4;
                    state.polygon_mode = .FACES_AND_WIREFRAME;
                case SDLK_5;
                    state.polygon_mode = .TEXTURE;
                case SDLK_6;
                    state.polygon_mode = .TEXTURE_AND_WIREFRAME;
                case SDLK_c;
                    state.cull_backfaces = .BACKFACES;
                case SDLK_d;
                    state.cull_backfaces = .NONE;
                case SDLK_w;
                    state.camera.forward_velocity = state.camera.direction * 0.1; // This should be multiplied by delta_time
                    state.camera.position += state.camera.forward_velocity;
                case SDLK_a;
                    state.camera.yaw -= 0.01; // This should be multiplied by delta_time
                case SDLK_r;
                    state.camera.forward_velocity = state.camera.direction * 0.1; // This should be multiplied by delta_time
                    state.camera.position -= state.camera.forward_velocity;
                case SDLK_s;
                    state.camera.yaw += 0.01; // This should be multiplied by delta_time
                case SDLK_UP;
                    state.camera.position.y += 0.1; // This should be multiplied by delta_time
                case SDLK_DOWN;
                    state.camera.position.y -= 0.1; // This should be multiplied by delta_time
            }
        case .SDL_QUIT;
            state.is_running = false;
    }
}

update :: () {
    delta_time: float;
    { // Control FPS
        current_frame_time_millis := seconds_since_init() * 1000;
        time_to_wait := FRAME_TARGET_TIME_MILLIS - (current_frame_time_millis - state.previous_frame_time_millis);
        if time_to_wait > 0 && time_to_wait <= FRAME_TARGET_TIME_MILLIS {
            sleep_milliseconds(xx time_to_wait);
        }
        delta_time_millis := seconds_since_init() * 1000 - state.previous_frame_time_millis;
        state.previous_frame_time_millis = seconds_since_init() * 1000;

        delta_time = xx (delta_time_millis / 1000.0); // converting to seconds
    }

    { // Update camera and make view matrix
        target := My_Math.Vector3.{ 0, 0, 1 };
        camera_yaw_rotation := My_Math.make_rotation_around_y_matrix(state.camera.yaw);
        state.camera.direction = (camera_yaw_rotation * target).xyz;
        target = state.camera.position + state.camera.direction;

        WORLD_UP :: My_Math.Vector3.{ 0, 1, 0 };

        state.view_matrix = My_Math.make_look_at_matrix(state.camera.position, target, WORLD_UP);
    }

    array_reset_keeping_memory(*state.triangles_to_render);

    world_matrix := My_Math.Matrix4_Identity;
    { // Transform the mesh
        translation_matrix       := My_Math.make_translation_matrix(state.mesh.translation);
        scale_matrix             := My_Math.make_scale_matrix(state.mesh.scale);
        rotation_around_x_matrix := My_Math.make_rotation_around_x_matrix(state.mesh.rotation.x);
        rotation_around_y_matrix := My_Math.make_rotation_around_y_matrix(state.mesh.rotation.y);
        rotation_around_z_matrix := My_Math.make_rotation_around_z_matrix(state.mesh.rotation.z);

        // Order matters!
        // First      - Scale
        // Then       - Rotate
        // At the end - Translate
        // [T]*[R]*[S]*v (read right to left...)
        world_matrix = scale_matrix             * world_matrix;
        world_matrix = rotation_around_z_matrix * world_matrix;
        world_matrix = rotation_around_y_matrix * world_matrix;
        world_matrix = rotation_around_x_matrix * world_matrix;
        world_matrix = translation_matrix       * world_matrix;
    }

    normalized_sun_direction := My_Math.normalize(state.sun.direction);

    for face: state.mesh.faces {
        face_vertices := My_Math.Vector3.[
            state.mesh.vertices[face.a],
            state.mesh.vertices[face.b],
            state.mesh.vertices[face.c],
        ];

        // Transform
        transformed_vertices: [3]My_Math.Vector4;
        for face_vertex: face_vertices {
            transformed := world_matrix * face_vertex;
            transformed = state.view_matrix * transformed;

            transformed_vertices[it_index] = transformed;
        }

        // We calculate this ourselves, but .obj files contain normal data
        face_normal: My_Math.Vector3;
        {
            vertex_a := transformed_vertices[0].xyz;
            vertex_b := transformed_vertices[1].xyz;
            vertex_c := transformed_vertices[2].xyz;

            vector_ab := vertex_b - vertex_a;
            vector_ac := vertex_c - vertex_a;

            face_normal = My_Math.normalize(My_Math.cross(vector_ab, vector_ac));
        }

        // Cull backfaces
        if #complete state.cull_backfaces == {
            case .BACKFACES;
                vertex_a := transformed_vertices[0].xyz;
                origin_ray := My_Math.Vector3.{} - vertex_a; // Why vertex_a exactly?
                alingment := My_Math.dot(face_normal, origin_ray);

                if alingment <= 0 {
                    continue; // reset the loop, so we don't add this triangle to the list of triangles to be rendered.
                }
            case .NONE;
                // Do nothing
        }

        // Shade
        face_color: u32;
        {
            // We multiply by -1 because we want to represent light's direction as a direction from the light source
            alignment := -My_Math.dot(face_normal, normalized_sun_direction);

            face_color = apply_light_intensity(face.color, alignment);
        }

        // Project
        projected_triangle: Triangle.Triangle = {
            color = face_color,
            uvs[0] = face.a_uv,
            uvs[1] = face.b_uv,
            uvs[2] = face.c_uv,
        };
        for transformed: transformed_vertices {
            projected_triangle.points[it_index] = My_Math.project_vector_perspective(state.projection_matrix, transformed);

            // This is viewport transform
            projected_triangle.points[it_index].x *= Display.window_width / 2;
            projected_triangle.points[it_index].y *= Display.window_height / 2;

            // Flip y because our pixel buffer has y down (because we start in the upper left corner), but the models have y up
            projected_triangle.points[it_index].y *= -1;

            // This is viewport transform
            projected_triangle.points[it_index].x += Display.window_width / 2;
            projected_triangle.points[it_index].y += Display.window_height / 2;
        }

        array_add(*state.triangles_to_render, projected_triangle);
    }
}

render :: () {
    Display.start_drawing();

    want_vertices: bool;
    want_wireframe: bool;
    want_faces: bool;
    want_texture: bool;

    if #complete state.polygon_mode == {
        case .WIREFRAME_AND_VERTICES;
            want_vertices  = true;
            want_wireframe = true;
        case .FACES;
            want_faces = true;
        case .WIREFRAME;
            want_wireframe = true;
        case .FACES_AND_WIREFRAME;
            want_faces     = true;
            want_wireframe = true;
        case .TEXTURE;
            want_texture = true;
        case .TEXTURE_AND_WIREFRAME;
            want_texture   = true;
            want_wireframe = true;
    }

    for triangle: state.triangles_to_render {
        if want_faces {
            Display.draw_filled_triangle(
                xx triangle.points[0].x, xx triangle.points[0].y,
                xx triangle.points[1].x, xx triangle.points[1].y,
                xx triangle.points[2].x, xx triangle.points[2].y,
                triangle.color,
            );
        }

        if want_texture {
            Display.draw_textured_triangle(
                xx triangle.points[0].x, xx triangle.points[0].y, triangle.points[0].z, triangle.points[0].w, triangle.uvs[0].u, triangle.uvs[0].v,
                xx triangle.points[1].x, xx triangle.points[1].y, triangle.points[1].z, triangle.points[1].w, triangle.uvs[1].u, triangle.uvs[1].v,
                xx triangle.points[2].x, xx triangle.points[2].y, triangle.points[2].z, triangle.points[2].w, triangle.uvs[2].u, triangle.uvs[2].v,
                state.mesh_texture,
            );
        }

        if want_vertices {
            for point: triangle.points {
                Display.draw_filled_rectangle(
                    xx point.x,
                    xx point.y,
                    4,
                    4,
                    0xFF0000FF,
                );
            }
        }

        if want_wireframe {
            Display.draw_triangle(
                xx triangle.points[0].x, xx triangle.points[0].y,
                xx triangle.points[1].x, xx triangle.points[1].y,
                xx triangle.points[2].x, xx triangle.points[2].y,
                0xFFFFFF00,
            );
        }
    }

    Display.finish_drawing();
}

setup_formatting :: () {
    print_style := *context.print_style;

    print_style.default_format_struct.draw_type_name = true;
    print_style.default_format_struct.use_long_form_if_more_than_this_many_members = 0;
    print_style.default_format_struct.use_newlines_if_long_form = true;
}

using,only(operator -, operator *, operator +=, operator +) My_Math;
