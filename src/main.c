#include <stdbool.h>
#include "display.h"

// Forward declarations
void setup(void);
void destroy(void);
void process_input(void);
void update(void);
void render(void);

bool is_running = false;

int main() {
    is_running = initialize_display();

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

void setup(void) {}

void destroy(void) {
    destroy_display();
}

// @TODO: move this out
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

void update(void) {}

void render(void) {
    start_drawing();

    draw_rectangle(100, 100, 50, 80, 0xFFFF0000);
    draw_rectangle(300, 800, 150, 3000, 0xFF0000FF);
    draw_pixel(500, 100, 0xFFFF0000);
    draw_pixel(501, 100, 0xFFFF0000);
    draw_pixel(500, 101, 0xFFFF0000);
    draw_pixel(501, 102, 0xFFFF0000);

    finish_drawing();
}
