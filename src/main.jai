#import "Basic"()(MEMORY_DEBUGGER=true);
#import "Math";
#import "SDL";
#import,file "display.jai";
#import,file "vector.jai";

is_running: bool;
previous_frame_time: int; // Milliseconds

// The cube
FOV_FACTOR :: 640;
CUBE_POINTS_COUNT :: 9 * 9 * 9;

Cube :: struct {
    points: [CUBE_POINTS_COUNT]Vector3;
    projected_points: [CUBE_POINTS_COUNT]Vector2;
    rotation: Vector3 = .{0, 0, 0};
}

cube: Cube;

// Camera
Camera :: struct {
    position: Vector3;
}

camera: Camera = .{
    position = .{0, 0, -5}
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

    display_destroy();
}

setup :: () {
    is_running = true;

    // Init the cube
    point_count: s64 = 0;
    x := -1.0;
    y := -1.0;
    z := -1.0;
    step := 0.25;
    while x <= 1.0 {
        defer x += step;

        while y <= 1.0 {
            defer y += step;

            while z <= 1.0 {
                defer z += step;

                cube.points[point_count] = .{x, y, z};
                point_count += 1;
            }

            z = -1;
        }

        y = -1;
    }
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

    cube.rotation.x += 0.01;
    cube.rotation.y += 0.01;
    cube.rotation.z += 0.01;

    for point: cube.points {
        // Rotate
        transformed := rotate_around_x(point, cube.rotation.x);
        transformed = rotate_around_y(transformed, cube.rotation.y);
        transformed = rotate_around_z(transformed, cube.rotation.z);

        // Translate
        transformed -= camera.position;

        cube.projected_points[it_index] = project_persp(transformed);
    }
}

render :: () {
    start_drawing();

    for point: cube.projected_points {
        draw_rectangle(
            // Add half of window size to translate to the middle of the screen;
            xx point.x + window_width / 2,
            xx point.y + window_height / 2,
            4, 4,
            0xFFFFFF00
        );
    }

    finish_drawing();
}

project_ortho :: (point: Vector3) -> Vector2 {
    return .{point.x, point.y} * FOV_FACTOR;
}

project_persp :: (point: Vector3) -> Vector2 {
    return .{
        point.x * FOV_FACTOR / point.z,
        point.y * FOV_FACTOR / point.z,
    };
}
