#import "Basic"()(MEMORY_DEBUGGER=true);
#import "SDL";
#import,file "display.jai";

is_running: bool;

main :: () {
    display_init();

    setup();

    while is_running {
        process_input();
        update();
        render();
    }

    display_destroy();
}

setup :: () {
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

update :: () {}

render :: () {
    start_drawing();

    draw_rectangle(100, 100, 100, 100, 0xFFFFFF00);

    finish_drawing();
}
