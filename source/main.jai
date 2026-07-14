#placeholder DEBUG;

#import "Basic"()(
    MEMORY_DEBUGGER                 = DEBUG,
    TEMP_ALLOCATOR_OVERWRITE_MEMORY = DEBUG,
);

Display :: #import,file "display.jai";
Vector  :: #import,file "vector.jai";

#import "SDL";

Cube :: struct {
    point_positions: [9 * 9 * 9]Vector.Vector3;

    rotation: Vector.Vector3;

    projected_point_positions: [9 * 9 * 9]Vector.Vector2;
}

Camera :: struct {
    position: Vector.Vector3 = { 0, 0, -3 };
    fov:      int            = 640;
}

cube:   Cube;
camera: Camera;

is_running: bool;

main :: () {
    defer report_memory_leaks();

    setup_formatting();

    Display.init();
    defer Display.deinit();

    setup();
    defer destroy();

    while is_running {
        process_input();
        update();
        render();
    }
}

setup :: () {
    { // Generate cube points
        cursor: u32;

        x: float = -1;
        while x <= 1 {
            defer x += 0.25;

            y: float = -1;
            while y <= 1 {
                defer y += 0.25;

                z: float = -1;
                while z <= 1 {
                    defer z += 0.25;
                    defer cursor += 1;

                    cube.point_positions[cursor] = { x, y, z };
                }
            }
        }
    }

    is_running = true;
}

destroy :: () {}

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
    cube.rotation.x += 0.01;
    cube.rotation.y += 0.01;
    cube.rotation.z += 0.01;

    // Project the cube points
    for point_position: cube.point_positions {
        transformed_point := Vector.rotate_around_x(point_position, cube.rotation.x);
        transformed_point = Vector.rotate_around_y(transformed_point, cube.rotation.y);
        transformed_point = Vector.rotate_around_z(transformed_point, cube.rotation.z);

        transformed_point.z -= camera.position.z;

        cube.projected_point_positions[it_index] = project_perspective(
            transformed_point,
            camera.fov,
        );
    }
}

render :: () {
    Display.start_drawing();

    Display.draw_grid(0xFF333333, 10);

    // Draw (projected) cube points
    for cube.projected_point_positions {
        Display.draw_rectangle(
            xx (it.x + Display.window_width / 2),
            xx (it.y + Display.window_height / 2),
            4,
            4,
            0xFFFFFF00,
        );
    }

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
