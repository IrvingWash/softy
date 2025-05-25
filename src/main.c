#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include <assert.h>
#include <SDL2/SDL.h>

// Constants
int WINDOW_WIDTH;
int WINDOW_HEIGHT;

// Globals
SDL_Window* window = NULL;
SDL_Renderer* renderer = NULL;
SDL_Texture* color_buffer_texture = NULL;
bool is_running = false;
uint32_t* color_buffer = NULL;

// Forward declarations
bool initialize_window(void);
void setup(void);
void destroy(void);
void process_input(void);
void update(void);
void render(void);
void clear_color_buffer(uint32_t clear_color);
void set_color_to_buffer(int row, int col, uint32_t color);
uint32_t get_color_from_buffer(int row, int col);
void render_color_buffer(void);
void draw_rectangle(int x, int y, int width, int height, uint32_t color);

int main() {
    is_running = initialize_window();

    if (!is_running) {
        return 1;
    }

    setup();

    while (is_running) {
        process_input();
        update();
        render();
    }

    destroy();

    return 0;
}

bool initialize_window(void) {
    if (SDL_Init(SDL_INIT_EVERYTHING) != 0) {
        fprintf(stderr, "Error initializing SDL\n");

        return false;
    }

    SDL_DisplayMode display_mode;
    SDL_GetCurrentDisplayMode(0, &display_mode);
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

    return true;
}

void setup(void) {
    color_buffer_texture = SDL_CreateTexture(
        renderer,
        SDL_PIXELFORMAT_ARGB8888,
        SDL_TEXTUREACCESS_STREAMING,
        WINDOW_WIDTH,
        WINDOW_HEIGHT
    );

    color_buffer = (uint32_t*) malloc(sizeof(uint32_t) * WINDOW_WIDTH * WINDOW_HEIGHT);
    assert(color_buffer);
}

void destroy(void) {
    free(color_buffer);

    SDL_DestroyTexture(color_buffer_texture);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
}

void process_input(void) {
    SDL_Event event;

    SDL_PollEvent(&event);

    switch (event.type) {
        case SDL_QUIT:
            is_running = false;
            break;
        case SDL_KEYDOWN:
            if (event.key.keysym.sym == SDLK_ESCAPE)
                is_running = false;
            break;
    }
}

void update(void) {
    set_color_to_buffer(10, 20, 0xFFFF0000);
}

void render(void) {
    SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
    SDL_RenderClear(renderer);
    clear_color_buffer(0xFF000000);

    draw_rectangle(100, 100, 50, 80, 0xFFFF0000);
    draw_rectangle(300, 800, 150, 3000, 0xFF0000FF);

    render_color_buffer();

    SDL_RenderPresent(renderer);
}

void clear_color_buffer(uint32_t clear_color) {
    for (int row = 0; row < WINDOW_HEIGHT; row++) {
        for (int col = 0; col < WINDOW_WIDTH; col++) {
            set_color_to_buffer(row, col, clear_color);
        }
    }
}

void set_color_to_buffer(int row, int col, uint32_t color) {
    color_buffer[(WINDOW_WIDTH * row) + col] = color;
};

uint32_t get_color_from_buffer(int row, int col) {
    return color_buffer[(WINDOW_WIDTH * row) + col];
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
