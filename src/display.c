#include "display.h"

int WINDOW_WIDTH;
int WINDOW_HEIGHT;

SDL_Window* window = NULL;
SDL_Renderer* renderer = NULL;

uint32_t* color_buffer = NULL;
SDL_Texture* color_buffer_texture = NULL;

void display_init(void) {
    // SDL
    assert(SDL_Init(SDL_INIT_EVERYTHING) == 0);

    // Window
    SDL_DisplayMode display_mode;
    assert(SDL_GetCurrentDisplayMode(0, &display_mode) == 0);
    WINDOW_WIDTH = display_mode.w;
    WINDOW_HEIGHT = display_mode.h;
    window = SDL_CreateWindow(
        "softy",
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        WINDOW_WIDTH, WINDOW_HEIGHT,
        SDL_WINDOW_BORDERLESS
    );
    assert(window);
    SDL_SetWindowFullscreen(window, SDL_WINDOW_FULLSCREEN);

    // Renderer
    renderer = SDL_CreateRenderer(window, -1, 0);
    assert(renderer);

    // Color buffer
    color_buffer = malloc(sizeof(uint32_t) * WINDOW_WIDTH * WINDOW_HEIGHT);
    assert(color_buffer);

    // Color buffer texture
    color_buffer_texture = SDL_CreateTexture(
        renderer,
        SDL_PIXELFORMAT_ARGB8888,
        SDL_TEXTUREACCESS_STREAMING,
        WINDOW_WIDTH,
        WINDOW_HEIGHT
    );
    assert(color_buffer_texture);
}

void display_destroy(void) {
    free(color_buffer);
    SDL_DestroyTexture(color_buffer_texture);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
}

void set_color_to_buffer(int col, int row, uint32_t color) {
    if (
        col > WINDOW_WIDTH
        || col < 0
        || row > WINDOW_HEIGHT
        || row < 0
    ) {
        return;
    }

    color_buffer[row * WINDOW_WIDTH + col] = color;
}

void clear_color_buffer(uint32_t color) {
    for (int x = 0; x < WINDOW_WIDTH; x++) {
        for (int y = 0; y < WINDOW_HEIGHT; y++) {
            set_color_to_buffer(x, y, color);
        }
    }
}

void render_color_buffer(void) {
    SDL_UpdateTexture(
        color_buffer_texture,
        NULL,
        color_buffer,
        sizeof(uint32_t) * WINDOW_WIDTH
    );

    SDL_RenderCopy(
        renderer,
        color_buffer_texture,
        NULL, NULL
    );
}

void start_drawing(void) {
    SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
    SDL_RenderClear(renderer);
    clear_color_buffer(0xFF000000);
}

void finish_drawing(void) {
    render_color_buffer();
    SDL_RenderPresent(renderer);
}

void draw_pixel (int x, int y, uint32_t color) {
    set_color_to_buffer(x, y, color);
}

void draw_rectangle(int x, int y, int width, int height, uint32_t color) {
    // Don't do anything offscreen
    if (x > WINDOW_WIDTH || y > WINDOW_HEIGHT) {
        return;
    }

    // Reduce the rectangle size if it partially goes out of the screen
    if (x + width > WINDOW_WIDTH) {
        width = WINDOW_WIDTH - x;
    }
    if (y + height > WINDOW_WIDTH) {
        height = WINDOW_HEIGHT - y;
    }
    if (x < 0) {
        width = 0 - x;
    }
    if (y < 0) {
        height = 0 - x;
    }

    for (int col = x; col < x + width; col++) {
        for (int row = y; row < y + height; row++) {
            draw_pixel(col, row, color);
        }
    }
}
