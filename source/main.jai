#placeholder DEBUG;

#import "Basic"()(
    MEMORY_DEBUGGER                 = DEBUG,
    TEMP_ALLOCATOR_OVERWRITE_MEMORY = DEBUG,
);

#import "Sort";

#import "SDL";

Display  :: #import,file "display.jai";
My_Math  :: #import,file "my_math.jai";
Triangle :: #import,file "triangle.jai";
Mesh     :: #import,file "mesh.jai";
Obj      :: #import,file "obj_parser.jai";

State :: struct {
    previous_frame_time_millis: float64;
    is_running: bool;

    polygon_mode:   Polygon_Mode;
    cull_backfaces: Cull_Mode;

    camera: Camera;
    mesh: Mesh.Mesh;

    triangles_to_render: [..]Triangle.Triangle;
}

Polygon_Mode :: enum {
    WIREFRAME_AND_VERTICES;
    WIREFRAME;
    FACES;
    FACES_AND_WIREFRAME;
}

Cull_Mode :: enum {
    BACKFACES;
    NONE;
}

Camera :: struct {
    position: My_Math.Vector3 = { 0, 0, 0 };
    fov:      int            = 640;
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

    obj := Obj.parse("assets/cube.obj");
    defer Obj.destroy(*obj);
    state.mesh = Mesh.create_mesh(obj.vertices, obj.faces);
    state.mesh.faces[0].color  = 0xFFFF0000;
    state.mesh.faces[1].color  = 0xFFFF0000;
    state.mesh.faces[2].color  = 0xFF00FF00;
    state.mesh.faces[3].color  = 0xFF00FF00;
    state.mesh.faces[4].color  = 0xFF0000FF;
    state.mesh.faces[5].color  = 0xFF0000FF;
    state.mesh.faces[6].color  = 0xFFFFFF00;
    state.mesh.faces[7].color  = 0xFFFFFF00;
    state.mesh.faces[8].color  = 0xFF00FFFF;
    state.mesh.faces[9].color  = 0xFF00FFFF;
    state.mesh.faces[10].color = 0xFFFFFFFF;
    state.mesh.faces[11].color = 0xFFFFFFFF;
}

destroy :: () {
    array_free(state.triangles_to_render);

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
                case SDLK_c;
                    state.cull_backfaces = .BACKFACES;
                case SDLK_d;
                    state.cull_backfaces = .NONE;
            }
        case .SDL_QUIT;
            state.is_running = false;
    }
}

update :: () {
    delta_time: float64;
    { // Control FPS
        current_frame_time_millis := seconds_since_init() * 1000;
        time_to_wait := FRAME_TARGET_TIME_MILLIS - (current_frame_time_millis - state.previous_frame_time_millis);
        if time_to_wait > 0 && time_to_wait <= FRAME_TARGET_TIME_MILLIS {
            sleep_milliseconds(xx time_to_wait);
        }
        delta_time = seconds_since_init() * 1000 - state.previous_frame_time_millis;
        state.previous_frame_time_millis = seconds_since_init() * 1000;
    }

    array_reset_keeping_memory(*state.triangles_to_render);

    state.mesh.rotation.x += 0.01;
    state.mesh.rotation.y += 0.01;
    state.mesh.rotation.z += 0.01;

    for face: state.mesh.faces {
        face_vertices := My_Math.Vector3.[
            state.mesh.vertices[face.a - 1],
            state.mesh.vertices[face.b - 1],
            state.mesh.vertices[face.c - 1],
        ];

        // Transform
        transformed_vertices: [3]My_Math.Vector3;
        for face_vertex: face_vertices {
            transformed := My_Math.rotate_around_x(face_vertex, state.mesh.rotation.x);
            transformed = My_Math.rotate_around_y(transformed, state.mesh.rotation.y);
            transformed = My_Math.rotate_around_z(transformed, state.mesh.rotation.z);

            transformed.z += 5;

            transformed_vertices[it_index] = transformed;
        }

        // Cull backfaces
        if #complete state.cull_backfaces == {
            case .BACKFACES;
                vertex_a := transformed_vertices[0];
                vertex_b := transformed_vertices[1];
                vertex_c := transformed_vertices[2];

                vector_ab := vertex_b - vertex_a;
                vector_ac := vertex_c - vertex_a;

                // We calculate this ourselves, but .obj files contain normal data
                normal     := My_Math.normalize(My_Math.cross(vector_ab, vector_ac));
                camera_ray := state.camera.position - vertex_a;

                alingment := My_Math.dot(normal, camera_ray);

                if alingment <= 0 {
                    continue;
                }
            case .NONE;
                // Do nothing
        }

        // Project
        projected_triangle: Triangle.Triangle = {
            color = face.color,
            average_depth = (transformed_vertices[0].z + transformed_vertices[1].z + transformed_vertices[2].z) / 3.0,
        };
        for transformed: transformed_vertices {
            projected := project_perspective(transformed, state.camera.fov);

            projected.x += Display.window_width / 2;
            projected.y += Display.window_height / 2;

            projected_triangle.points[it_index] = projected;
        }

        array_add(*state.triangles_to_render, projected_triangle);
    }

    quick_sort(
        state.triangles_to_render,
        (a: Triangle.Triangle, b: Triangle.Triangle) -> float { return b.average_depth - a.average_depth; }
    );
}

render :: () {
    Display.start_drawing();

    want_vertices: bool;
    want_wireframe: bool;
    want_faces: bool;

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

project_ortho :: (point_3d: My_Math.Vector3, fov_factor := 60) -> My_Math.Vector2 {
    return My_Math.Vector2.{
        x = point_3d.x * fov_factor,
        y = point_3d.y * fov_factor,
    };
}

project_perspective :: (point: My_Math.Vector3, fov_factor := 60) -> My_Math.Vector2 {
    return My_Math.Vector2.{
        x = (point.x * fov_factor) / point.z,
        y = (point.y * fov_factor) / point.z,
    };
}

setup_formatting :: () {
    print_style := *context.print_style;

    print_style.default_format_struct.draw_type_name = true;
    print_style.default_format_struct.use_long_form_if_more_than_this_many_members = 0;
    print_style.default_format_struct.use_newlines_if_long_form = true;
}

using,only(operator -) My_Math;
