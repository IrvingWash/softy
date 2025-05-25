#include <stdbool.h>
#include "display.h"
#include "vector.h"

bool is_running = false;

#define NUMBER_OF_POINST (9 * 9 * 9)
Vector3 cube_points[NUMBER_OF_POINST];
Vector2 projected_points[NUMBER_OF_POINST];
const float FOV_FACTOR = 640;
Vector3 camera_position = {0, 0, -5};

// Forward declarations
void setup(void);
void destroy(void);
void process_input(void);
void update(void);
void render(void);

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

void setup(void) {
    int curernt_point = 0;
    for (float x = -1; x <= 1; x += 0.25) {
        for (float y = -1; y <= 1; y += 0.25) {
            for (float z = -1; z <= 1; z += 0.25) {
                Vector3 point = { x, y, z };

                cube_points[curernt_point++] = point;
            }
        }
    }
}

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

Vector2 project(Vector3 point) {
    Vector2 projected = {
        point.x / (point.z == 0 ? 1 : point.z) * FOV_FACTOR,
        point.y / (point.z == 0 ? 1 : point.z) * FOV_FACTOR,
    };

    return projected;
}

void update(void) {
    for (int i = 0; i < NUMBER_OF_POINST; i++) {
        Vector3 point = cube_points[i];

        point.z -= camera_position.z;

        Vector2 projected = project(point);

        projected_points[i] = projected;
    }
}

void render(void) {
    start_drawing();

    const float window_width = get_window_width();
    const float window_height = get_window_height();

    for (int i = 0; i < NUMBER_OF_POINST; i++) {
        Vector2 point = projected_points[i];

        draw_rectangle(
            point.x + window_width / 2,
            point.y + window_height / 2,
            4, 4,
            0xFFFFFF00
        );
    }

    finish_drawing();
}
