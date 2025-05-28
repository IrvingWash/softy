#include <stdbool.h>
#include "display.h"

bool is_running = false;

void setup(void);
void process_input(void);
void update(void);
void render(void);

int main() {
    display_init();

    setup();

    while (is_running) {
        process_input();
        update();
        render();
    }

    display_destroy();

    return 0;
}

void setup(void) {
    is_running = true;
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

void render(void) {
    start_drawing();

    draw_rectangle(100, 100, 100, 100, 0xFFFFFF00);

    finish_drawing();
}
