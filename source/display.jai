SDL_PIXELFORMAT_ARGB8888 :: 0x16362004;

window_width:  s32 = 800;
window_height: s32 = 600;

window:   *SDL_Window;
renderer: *SDL_Renderer;

color_buffer: [..]u32; // ARGB
color_buffer_texture: *SDL_Texture;

init :: () {
    init_window();

    array_resize(*color_buffer, window_width * window_height);

    color_buffer_texture = SDL_CreateTexture(
        renderer,
        SDL_PIXELFORMAT_ARGB8888,
        xx SDL_TextureAccess.STREAMING,
        window_width,
        window_height,
    );
}

deinit :: () {
    SDL_DestroyTexture(color_buffer_texture);

    array_free(color_buffer);

    destroy_window();
}

start_drawing :: () {
    clear_color_buffer(0xFF000000);
}

finish_drawing :: () {
    render_color_buffer();

    SDL_RenderPresent(renderer);
}

draw_rectangle :: (x: s32, y: s32, width: s32, height: s32, color: u32) {
    for w: 0..width - 1 {
        for h: 0..height - 1 {
            cx := x + w;
            cy := y + h;

            draw_pixel(cx, cy, color);
        }
    }
}

draw_grid :: (grid_color: u32, grid_size: s32) {
    for y: 0..window_height - 1 {
        for x: 0..window_width - 1 {
            if x % grid_size == 0 || y % grid_size == 0 {
                draw_pixel(xx x, xx y, grid_color);
            }
        }
    }
}

draw_pixel :: (x: s32, y: s32, color: u32) {
    if (
        x >= 0 && x < window_width
        && y >= 0 && y < window_height
    ) {
        color_buffer[y * xx window_width + x] = color;
    }
}



#scope_file

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

#import "Basic";
#import "SDL";
Vector :: #import,file "vector.jai";
