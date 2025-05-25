#pragma once

#include <stdint.h>
#include <stdbool.h>
#include <SDL2/SDL.h>

bool initialize_display(void);
void destroy_display(void);

void start_drawing(void);
void finish_drawing(void);

void draw_rectangle(int x, int y, int width, int height, uint32_t color);
