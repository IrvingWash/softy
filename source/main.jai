#placeholder DEBUG;

#import "Basic"()(
    MEMORY_DEBUGGER                 = DEBUG,
    TEMP_ALLOCATOR_OVERWRITE_MEMORY = DEBUG,
);

Display :: #import,file "display.jai";
Vector  :: #import,file "vector.jai";

#import "SDL";

is_running: bool;

cube_points: [9 * 9 * 9]Vector.Vector3;

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

                    cube_points[cursor] = { x, y, z };
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

update :: () {}

render :: () {
    Display.start_drawing();

    Display.draw_grid(0xFF777777, 10);

    Display.draw_rectangle(300, 200, 300, 150, 0xFFFF0000);

    Display.finish_drawing();
}

setup_formatting :: () {
    print_style := *context.print_style;

    print_style.default_format_struct.draw_type_name = true;
    print_style.default_format_struct.use_long_form_if_more_than_this_many_members = 0;
    print_style.default_format_struct.use_newlines_if_long_form = true;
}
