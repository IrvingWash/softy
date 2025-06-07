#import "Basic"()(MEMORY_DEBUGGER=true);
#import "Math";
#import "SDL";
#import,file "display.jai";
#import,file "vector.jai";
#import,file "mesh.jai";
#import,file "triangle.jai";

is_running: bool;
previous_frame_time: int; // Milliseconds

FOV_FACTOR :: 640;

triangles_to_render: [..]Triangle;

camera: struct {
    position: Vector3 = .{0,0,0};
};

main :: () {
    display_init();

    setup();

    while is_running {
        process_input();
        update();
        render();
        memory_visualizer_per_frame_update();
    }

    array_free(triangles_to_render);
    destroy_mesh();
    display_destroy();
}

setup :: () {
    load_obj_data("./assets/cube.obj");

    is_running = true;
}

process_input :: () {
    event: SDL_Event;
    SDL_PollEvent(*event);

    if event.type == {
        case .SDL_QUIT;
            is_running = false;
        case .SDL_KEYDOWN;
            if event.key.keysym.sym == .SDLK_ESCAPE {
                is_running = false;
            }
    }
}

update :: () {
    time_to_wait := FRAME_TARGET_TIME - (SDL_GetTicks() - previous_frame_time);
    if time_to_wait > 0 && time_to_wait <= FRAME_TARGET_TIME {
        SDL_Delay(xx time_to_wait);
    }
    previous_frame_time = SDL_GetTicks();

    // Ugly
    if triangles_to_render.count != 0 {
        array_reset(*triangles_to_render);
    }

    mesh.rotation.x += 0.01;
    mesh.rotation.y += 0.01;
    mesh.rotation.z += 0.01;

    // Make triangles to render
    for face: mesh.faces {
        face_vertices: [3]Vector3 = .[
            mesh.vertices[face.a - 1],
            mesh.vertices[face.b - 1],
            mesh.vertices[face.c - 1],
        ];

        // Transform
        triangle_transformed_vertices: [3]Vector3;
        for vertex: face_vertices {
            // Rotate
            transformed := rotate_around_x(vertex, mesh.rotation.x);
            transformed = rotate_around_y(transformed, mesh.rotation.y);
            transformed = rotate_around_z(transformed, mesh.rotation.z);

            // Translate
            transformed.z += 5;

            // Store to pass to projection phaze
            triangle_transformed_vertices[it_index] = transformed;
        }

        // Cull backfaces
        {
            v_a := triangle_transformed_vertices[0];
            v_b := triangle_transformed_vertices[1];
            v_c := triangle_transformed_vertices[2];

            // No need to normalize at this point.
            v_ab := normalize(v_b - v_a);
            // No need to normalize at this point.
            v_ac := normalize(v_c - v_a);

            // No need to normalize at this point.
            normal := normalize(cross_product(v_ab, v_ac));

            camera_ray := camera.position - v_a;

            normal_and_camera_alignment := dot_product(normal, camera_ray);

            if normal_and_camera_alignment < 0 {
                // Don't project and don't store in triangles_to_render
                continue;
            }
        }

        processed_triangle: Triangle;
        // Project
        for vertex: triangle_transformed_vertices {
            projected := project_persp(vertex);

            // Scale and translate (why here and not in the Transform phaze above?..)
            projected.x += window_width / 2;
            projected.y += window_height / 2;

            // Store finalized vertices that will be rendered
            processed_triangle.points[it_index] = projected;
        }

        array_add(*triangles_to_render, processed_triangle);
    }
}

render :: () {
    start_drawing();

    // for triangle: triangles_to_render {
    //     draw_triangle(
    //         xx triangle.points[0].x,
    //         xx triangle.points[0].y,
    //         xx triangle.points[1].x,
    //         xx triangle.points[1].y,
    //         xx triangle.points[2].x,
    //         xx triangle.points[2].y,
    //         0xFFFFFF00,
    //     );
    // }

    draw_triangle_filled(300, 100, 50, 400, 500, 700, 0xFF00FF00);

    finish_drawing();
}

project_persp :: (point: Vector3) -> Vector2 {
    return .{
        point.x * FOV_FACTOR / point.z,
        point.y * FOV_FACTOR / point.z,
    };
}

project_ortho :: (point: Vector3) -> Vector2 {
    // Why FOV_FACTORing here?
    return .{point.x, point.y} * FOV_FACTOR;
}
