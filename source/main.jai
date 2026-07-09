#placeholder DEBUG;

#import "Basic"()(
    MEMORY_DEBUGGER                 = DEBUG,
    TEMP_ALLOCATOR_OVERWRITE_MEMORY = DEBUG,
);

#import "SDL";

WINDOW_WIDTH  :: 800;
WINDOW_HEIGHT :: 600;

window:   *SDL_Window;
renderer: *SDL_Renderer;

is_running: bool;

color_buffer: [..]u32; // ARGB

main :: () {
    defer report_memory_leaks();

    window, renderer = init_window();
    defer destroy_window();

    setup();
    defer destroy();

    while is_running {
        process_input();
        update();
        render();
    }
}

setup :: () {
    array_resize(*color_buffer, WINDOW_WIDTH * WINDOW_HEIGHT);

    is_running = true;
}

destroy :: () {
    array_free(color_buffer);
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

update :: () {}

render :: () {
    SDL_SetRenderDrawColor(renderer, 255, 0, 0, 255);
    SDL_RenderClear(renderer);

    SDL_RenderPresent(renderer);
}

init_window :: () -> *SDL_Window, *SDL_Renderer {
    result := SDL_Init(SDL_INIT_VIDEO);
    assert(result == 0, "Failed to initialize SDL");

    window := SDL_CreateWindow(
        "Softy",
        SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        SDL_WINDOW_BORDERLESS,
    );
    assert(window != null, "Failed to create SDL window");

    renderer := SDL_CreateRenderer(window, -1, 0);
    assert(renderer != null, "Failed to create SDL renderer");

    return window, renderer;
}

destroy_window :: () {
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
}
