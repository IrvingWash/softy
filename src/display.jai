#import "Basic";
#import "SDL";

// Didn't found this in the bindings
SDL_PIXELFORMAT_ARGB8888 :: 372645892;

window_width: s32;
window_height: s32;

window: *SDL_Window;
renderer: *SDL_Renderer;
color_buffer_texture: *SDL_Texture;

// SDL wants this to be *u32, lazy to try to pass a [..]u32
color_buffer: *u32;

display_init :: () {
    // SDL
    ok := SDL_Init(SDL_INIT_EVERYTHING);
    assert(ok == 0);

    // Window
    display_mode: SDL_DisplayMode;
    ok = SDL_GetCurrentDisplayMode(0, *display_mode);
    assert(ok == 0);
    window_width = display_mode.w;
    window_height = display_mode.h;
    window = SDL_CreateWindow(
        "softy",
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        window_width, window_height,
        SDL_WINDOW_BORDERLESS
    );
    assert(window != null);
    SDL_SetWindowFullscreen(window, xx SDL_WINDOW_FULLSCREEN);

    // Renderer
    renderer = SDL_CreateRenderer(window, -1, 0);
    assert(renderer != null);

    // Texture
    color_buffer_texture = SDL_CreateTexture(
        renderer,
        SDL_PIXELFORMAT_ARGB8888,
        xx SDL_TextureAccess.STREAMING,
        window_width,
        window_height
    );
    assert(color_buffer_texture != null);

    color_buffer = alloc(window_width * window_height * size_of(u32));
}

display_destroy :: () {
    free(color_buffer);

    SDL_DestroyTexture(color_buffer_texture);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
}

start_drawing :: () {
    SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
    SDL_RenderClear(renderer);
    clear_color_buffer(0xFF000000);
}

finish_drawing :: () {
    render_color_buffer();
    SDL_RenderPresent(renderer);
}

draw_pixel :: (x: int, y: int, color: u32) {
    set_color_to_buffer(x, y, color);
}

draw_rectangle :: (x: int, y: int, width: int, height: int, color: u32) {
    // Don't do anything offscreen
    if (x > window_width || y > window_height) {
        return;
    }

    // Reduce the rectangle size if it partially goes out of the screen
    if (x + width > window_width) {
        width = window_width - x;
    }
    if (y + height > window_height) {
        height = window_height - y;
    }
    if (x < 0) {
        width = 0 - x;
    }
    if (y < 0) {
        height = 0 - x;
    }

    for col: x..x + width - 1{
        for row: y..y + height - 1 {
            draw_pixel(col, row, color);
        }
    }
}

#scope_file;

set_color_to_buffer :: (col: int, row: int, color: u32) {
    if (
        col > window_width
        || col < 0
        || row > window_height
        || row < 0
    ) {
        return;
    }

    color_buffer[row * window_width + col] = color;
}

clear_color_buffer :: (color: u32) {
    for x: 0..window_width - 1 {
        for y: 0..window_height - 1 {
            set_color_to_buffer(x, y, color);
        }
    }
}

render_color_buffer :: () {
    SDL_UpdateTexture(
        color_buffer_texture,
        null,
        color_buffer,
        size_of(u32) * window_width
    );

    SDL_RenderCopy(
        renderer,
        color_buffer_texture,
        null, null
    );
}
