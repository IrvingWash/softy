#placeholder DEBUG;

#import "Basic"()(
    MEMORY_DEBUGGER                 = DEBUG,
    TEMP_ALLOCATOR_OVERWRITE_MEMORY = DEBUG,
);

#import "SDL";
SDL_PIXELFORMAT_ARGB8888 :: 0x16362004;

window_width:  s32 = 800;
window_height: s32 = 600;

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
    array_resize(*color_buffer, window_width * window_height);

    color_buffer_texture = SDL_CreateTexture(
        renderer,
        SDL_PIXELFORMAT_ARGB8888,
        xx SDL_TextureAccess.STREAMING,
        window_width,
        window_height,
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
        window_width * size_of(u32),
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

    display_mode: SDL_DisplayMode;
    SDL_GetCurrentDisplayMode(0, *display_mode);
    window_width  = display_mode.w;
    window_height = display_mode.h;

    window = SDL_CreateWindow(
        "Softy",
        SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED,
        xx window_width,
        xx window_height,
        SDL_WINDOW_BORDERLESS,
    );
    assert(window != null, "Failed to create SDL window");

    SDL_SetWindowFullscreen(window, xx SDL_WINDOW_FULLSCREEN);

    renderer = SDL_CreateRenderer(window, -1, 0);
    assert(renderer != null, "Failed to create SDL renderer");
}

destroy_window :: () {
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
}
