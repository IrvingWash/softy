#include <stdio.h>
#include <assert.h>
#include "display.h"

// Constants
int WINDOW_WIDTH;
int WINDOW_HEIGHT;

// Globals
SDL_Window* window = NULL;
SDL_Renderer* renderer = NULL;
SDL_Texture* color_buffer_texture = NULL;
uint32_t* color_buffer = NULL;

void clear_color_buffer(uint32_t clear_color);
void render_color_buffer(void);

bool initialize_display(void) {
    if (SDL_Init(SDL_INIT_EVERYTHING) != 0) {
        fprintf(stderr, "Error initializing SDL\n");

        return false;
    }

    SDL_DisplayMode display_mode;
    if (SDL_GetCurrentDisplayMode(0, &display_mode) != 0) {
        fprintf(stderr, "Error accessing monitor\n");

        return false;
    }
    WINDOW_WIDTH = display_mode.w;
    WINDOW_HEIGHT = display_mode.h;

    window = SDL_CreateWindow(
        "Softy",
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        WINDOW_WIDTH, WINDOW_HEIGHT,
        SDL_WINDOW_BORDERLESS
    );
    SDL_SetWindowFullscreen(window, SDL_WINDOW_FULLSCREEN);
    if (!window) {
        fprintf(stderr, "Error creating SDL window\n");

        return false;
    }

    renderer = SDL_CreateRenderer(window, -1, 0);
    if (!renderer) {
        fprintf(stderr, "Error creating SDL renderer\n");

        return false;
    }

    color_buffer_texture = SDL_CreateTexture(
        renderer,
        SDL_PIXELFORMAT_ARGB8888,
        SDL_TEXTUREACCESS_STREAMING,
        WINDOW_WIDTH,
        WINDOW_HEIGHT
    );

    color_buffer = (uint32_t*) malloc(sizeof(uint32_t) * WINDOW_WIDTH * WINDOW_HEIGHT);
    if (!color_buffer) {
        fprintf(stderr, "Failed to initialize color buffer\n");

        return false;
    }

    return true;
}

void destroy_display(void) {
    free(color_buffer);

    SDL_DestroyTexture(color_buffer_texture);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
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

void set_color_to_buffer(int row, int col, uint32_t color) {
    color_buffer[(WINDOW_WIDTH * row) + col] = color;
};

void clear_color_buffer(uint32_t clear_color) {
    for (int row = 0; row < WINDOW_HEIGHT; row++) {
        for (int col = 0; col < WINDOW_WIDTH; col++) {
            set_color_to_buffer(row, col, clear_color);
        }
    }
}

void render_color_buffer(void) {
    SDL_UpdateTexture(
        color_buffer_texture,
        NULL,
        color_buffer,
        (int) (WINDOW_WIDTH * sizeof(uint32_t))
    );

    SDL_RenderCopy(
        renderer,
        color_buffer_texture,
        NULL,
        NULL
    );
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
    if (y + height > WINDOW_HEIGHT) {
        height = WINDOW_HEIGHT - y;
    }

    for (int row = y; row < height + y; row++) {
        for (int col = x; col < width + x; col++) {
            set_color_to_buffer(row, col, color);
        }
    }
}

