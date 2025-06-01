#import "Basic"()(MEMORY_DEBUGGER=true);
#import "Math";
#import "SDL";
#import,file "display.jai";

is_running: bool;

// The cube
CUBE_POINTS_COUNT :: 9 * 9 * 9;

Cube :: struct {
    points: [CUBE_POINTS_COUNT]Vector3;
    projected_points: [CUBE_POINTS_COUNT]Vector2;
}

cube: Cube;

main :: () {
    display_init();

    setup();

    while is_running {
        process_input();
        update();
        render();
        sleep_milliseconds(16);
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
        }
    }
}

project_ortho :: (point: Vector3) -> Vector2 {
    return .{point.x, point.y};
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
        cube.projected_points[it_index] = project_ortho(point);
    }
}

render :: () {
    start_drawing();

    for point: cube.projected_points {
        draw_rectangle(
            xx point.x,
            xx point.y,
            4, 4,
            0xFFFFFF00
        );
    }

    finish_drawing();
}
