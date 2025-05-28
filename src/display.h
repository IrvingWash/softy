#pragma once

#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <SDL2/SDL.h>

void display_init(void);
void display_destroy(void);

void start_drawing(void);
void finish_drawing(void);

void draw_pixel (int x, int y, uint32_t color);
void draw_rectangle(int x, int y, int width, int height, uint32_t color);
