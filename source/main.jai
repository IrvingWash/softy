#placeholder DEBUG;

#import "Basic"()(
    MEMORY_DEBUGGER                 = DEBUG,
    TEMP_ALLOCATOR_OVERWRITE_MEMORY = DEBUG,
);

#import "SDL";
SDL_PIXELFORMAT_ARGB8888 :: 0x16362004;

WINDOW_WIDTH  :: 800;
WINDOW_HEIGHT :: 600;

window:   *SDL_Window;
renderer: *SDL_Renderer;

is_running: bool;

color_buffer: [..]u32; // ARGB
color_buffer_texture: *SDL_Texture;

main :: () {
    defer report_memory_leaks();

    init_window();
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

    color_buffer_texture = SDL_CreateTexture(
        renderer,
        SDL_PIXELFORMAT_ARGB8888,
        xx SDL_TextureAccess.STREAMING,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
    );

    is_running = true;
}

destroy :: () {
    SDL_DestroyTexture(color_buffer_texture);

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
    clear_color_buffer(0xFFFFFF00);

    render_color_buffer();

    SDL_RenderPresent(renderer);
}

render_color_buffer :: () {
    SDL_UpdateTexture(
        color_buffer_texture,
        null,
        color_buffer.data,
        WINDOW_WIDTH * size_of(u32),
    );

    SDL_RenderCopy(
        renderer,
        color_buffer_texture,
        null,
        null,
    );
}

clear_color_buffer :: (clear_color: u32) {
    for *color: color_buffer {
        color.* = clear_color;
    }
}

init_window :: () {
    result := SDL_Init(SDL_INIT_VIDEO);
    assert(result == 0, "Failed to initialize SDL");

    window = SDL_CreateWindow(
        "Softy",
        SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        SDL_WINDOW_BORDERLESS,
    );
    assert(window != null, "Failed to create SDL window");

    renderer = SDL_CreateRenderer(window, -1, 0);
    assert(renderer != null, "Failed to create SDL renderer");
}

destroy_window :: () {
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
}
