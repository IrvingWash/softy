#placeholder DEBUG;

#import "Basic"()(
    MEMORY_DEBUGGER                 = DEBUG,
    TEMP_ALLOCATOR_OVERWRITE_MEMORY = DEBUG,
);

Display :: #import,file "display.jai";

#import "SDL";

is_running: bool;

main :: () {
    defer report_memory_leaks();

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
