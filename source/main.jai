#placeholder DEBUG;

#import "Basic"()(
    MEMORY_DEBUGGER                 = DEBUG,
    TEMP_ALLOCATOR_OVERWRITE_MEMORY = DEBUG,
);

#import "SDL";

Display  :: #import,file "display.jai";
Vector   :: #import,file "vector.jai";
Triangle :: #import,file "triangle.jai";
Mesh     :: #import,file "mesh.jai";
Obj      :: #import,file "obj_parser.jai";

Camera :: struct {
    position: Vector.Vector3 = { 0, 0, 0 };
    fov:      int            = 640;
}

FPS: float : 60;
FRAME_TARGET_TIME_MILLIS: float : 1000.0 / FPS;

previous_frame_time_millis: float64;
is_running: bool;

camera: Camera;
mesh: Mesh.Mesh;

triangles_to_render: [..]Triangle.Triangle;

main :: () {
    #if DEBUG {
        defer report_memory_leaks();
    }

    setup_formatting();

    Display.init();
    defer Display.deinit();

    setup();
    defer destroy();

    while is_running {
        process_input();
        update();
        render();

        reset_temporary_storage();
    }
}

setup :: () {
    is_running = true;

    obj := Obj.parse("assets/cube.obj");
    defer Obj.destroy(*obj);
    mesh = Mesh.create_mesh(obj.vertices, obj.faces);
}

destroy :: () {
    array_free(triangles_to_render);

    Mesh.destroy_mesh(*mesh);
}

process_input :: () {
    event: SDL_Event;
    SDL_PollEvent(*event);

    if event.type == {
        case .SDL_KEYDOWN;
            if event.key.keysym.sym == SDLK_ESCAPE {
                is_running = false;
            }
        case .SDL_QUIT;
            is_running = false;
    }
}

update :: () {
    delta_time: float64;
    { // Control FPS
        current_frame_time_millis := seconds_since_init() * 1000;
        time_to_wait := FRAME_TARGET_TIME_MILLIS - (current_frame_time_millis - previous_frame_time_millis);
        if time_to_wait > 0 && time_to_wait <= FRAME_TARGET_TIME_MILLIS {
            sleep_milliseconds(xx time_to_wait);
        }
        delta_time = seconds_since_init() * 1000 - previous_frame_time_millis;
        previous_frame_time_millis = seconds_since_init() * 1000;
    }

    array_reset_keeping_memory(*triangles_to_render);

    mesh.rotation.x += 0.01;
    mesh.rotation.y += 0.01;
    mesh.rotation.z += 0.01;

    for face: mesh.faces {
        face_vertices := Vector.Vector3.[
            mesh.vertices[face.a - 1],
            mesh.vertices[face.b - 1],
            mesh.vertices[face.c - 1],
        ];

        // Transform
        transformed_vertices: [3]Vector.Vector3;
        for face_vertex: face_vertices {
            transformed := Vector.rotate_around_x(face_vertex, mesh.rotation.x);
            transformed = Vector.rotate_around_y(transformed, mesh.rotation.y);
            transformed = Vector.rotate_around_z(transformed, mesh.rotation.z);

            transformed.z += 5;

            transformed_vertices[it_index] = transformed;
        }

        // Cull back-faces
        {
            vertex_a := transformed_vertices[0];
            vertex_b := transformed_vertices[1];
            vertex_c := transformed_vertices[2];

            vector_ab := vertex_b - vertex_a;
            vector_ac := vertex_c - vertex_a;

            // We calculate this ourselves, but .obj files contain normal data
            normal     := Vector.normalize(Vector.cross(vector_ab, vector_ac));
            camera_ray := camera.position - vertex_a;

            alingment := Vector.dot(normal, camera_ray);

            if alingment <= 0 {
                continue;
            }
        }

        // Project
        projected_triangle: Triangle.Triangle;
        for transformed: transformed_vertices {
            projected := project_perspective(transformed, camera.fov);

            projected.x += Display.window_width / 2;
            projected.y += Display.window_height / 2;

            projected_triangle.points[it_index] = projected;
        }

        array_add(*triangles_to_render, projected_triangle);
    }
}

render :: () {
    Display.start_drawing();

    for triangle: triangles_to_render {
        for point: triangle.points {
            Display.draw_filled_rectangle(
                xx point.x,
                xx point.y,
                4,
                4,
                0xFFFFFF00,
            );
        }

        Display.draw_triangle(
            xx triangle.points[0].x, xx triangle.points[0].y,
            xx triangle.points[1].x, xx triangle.points[1].y,
            xx triangle.points[2].x, xx triangle.points[2].y,
            0xFF00FF00,
        );
    }

    Display.draw_filled_triangle(
        300, 100,
        50,  400,
        500, 700,
        0xFF00FF00,
    );

    Display.finish_drawing();
}

project_ortho :: (point_3d: Vector.Vector3, fov_factor := 60) -> Vector.Vector2 {
    return Vector.Vector2.{
        x = point_3d.x * fov_factor,
        y = point_3d.y * fov_factor,
    };
}

project_perspective :: (point: Vector.Vector3, fov_factor := 60) -> Vector.Vector2 {
    return Vector.Vector2.{
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

using,only(operator -) Vector;
