#include <SDL2/SDL.h>
#include <SDL2/SDL_video.h>
#include <assert.h>
#include <stdbool.h>
#include <stdint.h>

int WINDOW_WIDTH;
int WINDOW_HEIGHT;

SDL_Window* window = NULL;
SDL_Renderer* renderer = NULL;

bool is_running = false;

uint32_t* color_buffer = NULL;
SDL_Texture* color_buffer_texture = NULL;

void initialize_window(void) {
    assert(SDL_Init(SDL_INIT_EVERYTHING) == 0);

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

    renderer = SDL_CreateRenderer(window, -1, 0);
    assert(renderer);
}

void setup(void) {
    color_buffer = malloc(sizeof(uint32_t) * WINDOW_WIDTH * WINDOW_HEIGHT);
    assert(color_buffer);

    color_buffer_texture = SDL_CreateTexture(
        renderer,
        SDL_PIXELFORMAT_ARGB8888,
        SDL_TEXTUREACCESS_STREAMING,
        WINDOW_WIDTH,
        WINDOW_HEIGHT
    );
    assert(color_buffer_texture);

    is_running = true;
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
            if (event.key.keysym.sym == SDLK_ESCAPE) {
                is_running = false;
            }
            break;
    }
}

void update(void) {}

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

void render(void) {
    SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
    SDL_RenderClear(renderer);
    clear_color_buffer(0xFF000000);

    draw_rectangle(100, 100, 100, 100, 0xFFFFFF00);

    render_color_buffer();
    SDL_RenderPresent(renderer);
}

int main() {
    initialize_window();

    setup();

    while (is_running) {
        process_input();
        update();
        render();
    }

    destroy();

    return 0;
}
