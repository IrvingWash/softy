#import "Basic"()(MEMORY_DEBUGGER=true);
#import "Math";
#import "SDL";
#import,file "display.jai";

is_running: bool;

// The cube
FOV_FACTOR :: 640;
CUBE_POINTS_COUNT :: 9 * 9 * 9;

Cube :: struct {
    points: [CUBE_POINTS_COUNT]Vector3;
    projected_points: [CUBE_POINTS_COUNT]Vector2;
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
        sleep_milliseconds(16);
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

project_ortho :: (point: Vector3) -> Vector2 {
    return .{point.x, point.y} * FOV_FACTOR;
}

project_persp :: (point: Vector3) -> Vector2 {
    cameraed := point - camera.position;

    return .{cameraed.x, cameraed.y} / cameraed.z * FOV_FACTOR;
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
    for point: cube.points {
        cube.projected_points[it_index] = project_persp(point);
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
