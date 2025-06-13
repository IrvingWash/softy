#import "Basic";
#import "SDL";
#import "Math";
#import,file "vector.jai";

#scope_export;

// FPS
FPS :: 60;
M_IN_S: float : 1000;
FRAME_TARGET_TIME :: M_IN_S / FPS;

#scope_file;

// Didn't found this in the bindings
SDL_PIXELFORMAT_ARGB8888 :: 372645892;

#scope_export;

window_width: s32;
window_height: s32;

#scope_file;

window: *SDL_Window;
renderer: *SDL_Renderer;
color_buffer_texture: *SDL_Texture;

// SDL wants this to be *u32, lazy to try to pass a [..]u32
color_buffer: *u32;

// For some reason AUDIO doesn't work on my linux machine
#if OS == .LINUX {
    MY_SDL_INIT_FLAGS :: SDL_INIT_EVERYTHING & ~SDL_INIT_AUDIO;
} else {
    MY_SDL_INIT_FLAGS :: SDL_INIT_EVERYTHING;
}

#scope_export;

display_init :: () {
    // SDL
    ok := SDL_Init(MY_SDL_INIT_FLAGS);
    assert(ok == 0);

    // Window
    display_mode: SDL_DisplayMode;
    ok = SDL_GetCurrentDisplayMode(0, *display_mode);
    assert(ok == 0);
    window_width = display_mode.w;
    window_height = display_mode.h;
    window = SDL_CreateWindow(
        "softy",
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        window_width, window_height,
        SDL_WINDOW_BORDERLESS
    );
    assert(window != null);
    SDL_SetWindowFullscreen(window, xx SDL_WINDOW_FULLSCREEN);

    // Renderer
    renderer = SDL_CreateRenderer(window, -1, 0);
    assert(renderer != null);

    // Texture
    color_buffer_texture = SDL_CreateTexture(
        renderer,
        SDL_PIXELFORMAT_ARGB8888,
        xx SDL_TextureAccess.STREAMING,
        window_width,
        window_height
    );
    assert(color_buffer_texture != null);

    // Color buffer
    color_buffer = alloc(window_width * window_height * size_of(u32));
    assert(color_buffer != null);
}

display_destroy :: () {
    free(color_buffer);

    SDL_DestroyTexture(color_buffer_texture);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
}

start_drawing :: () {
    clear_color_buffer(0xFF000000);
}

finish_drawing :: () {
    render_color_buffer();
    SDL_RenderPresent(renderer);
}

draw_pixel :: (x: int, y: int, color: u32) {
    set_color_to_buffer(x, y, color);
}

draw_rectangle :: (x: int, y: int, width: int, height: int, color: u32) {
    // Don't do anything offscreen
    if x > window_width || y > window_height {
        return;
    }
    if x + width < 0 || y + height < 0 {
        return;
    }

    // Reduce the rectangle size if it partially goes out of the screen
    if x + width > window_width {
        width = window_width - x;
    }
    if y + height > window_height {
        height = window_height - y;
    }
    if x < 0 {
        width = 0 - x;
    }
    if y < 0 {
        height = 0 - x;
    }

    for col: x..x + width - 1{
        for row: y..y + height - 1 {
            draw_pixel(col, row, color);
        }
    }
}

draw_line :: (x0: int, y0: int, x1: int, y1: int, color: u32) {
    dx := x1 - x0;
    dy := y1 - y0;

    longest_side_length := ifx abs(dx) >= abs(dy) then abs(dx) else abs(dy);

    if longest_side_length == 0 {
        return;
    }

    x_inc: float = cast(float) dx / cast(float) longest_side_length;
    y_inc: float = cast(float) dy / cast(float) longest_side_length;

    current_x: float = xx x0;
    current_y: float = xx y0;
    for 0..longest_side_length {
        draw_pixel(round(current_x), round(current_y), color);

        current_x += x_inc;
        current_y += y_inc;
    }
}

draw_triangle :: (x0: int, y0: int, x1: int, y1: int, x2: int, y2: int, color: u32) {
    draw_line(x0, y0, x1, y1, color);
    draw_line(x1, y1, x2, y2, color);
    draw_line(x2, y2, x0, y0, color);
}

draw_triangle_filled :: (x0: int, y0: int, x1: int, y1: int, x2: int, y2: int, color: u32) {
    // Sort vertices
    if y0 > y1 {
        y0,y1 = y1,y0;
        x0,x1 = x1,x0;
    }
    if y1 > y2 {
        y1,y2 = y2,y1;
        x1,x2 = x2,x1;
    }
    if y0 > y1 {
        y0,y1 = y1,y0;
        x0,x1 = x1,x0;
    }

    if cast(float) (y2 - y0) == 0 {
        return;
    }

    // Find the mid point
    // @Scary check the casts
    my := y1;
    mx := (
        cast(float)(x2 - x0) * cast(float)(y1 - y0)
        / cast(float) (y2 - y0)
    ) + x0;

    // And finally draw
    draw_flat_bottom(x0, y0, x1, y1, xx mx, my, color);
    draw_flat_top(x1, y1, xx mx, my, x2, y2, color);
}

draw_triangle_textured :: (
    x0: int, y0: int, z0: float, w0: float, u0: float, v0: float,
    x1: int, y1: int, z1: float, w1: float, u1: float, v1: float,
    x2: int, y2: int, z2: float, w2: float, u2: float, v2: float,
    texture: []u32
) {
    // @Copy_and_paste

    // Sort vertices
    if y0 > y1 {
        y0,y1 = y1,y0;
        x0,x1 = x1,x0;
        z0,z1 = z1,z0;
        w0,w1 = w1,w0;
        u0,u1 = u1,u0;
        v0,v1 = v1,v0;
    }
    if y1 > y2 {
        y1,y2 = y2,y1;
        x1,x2 = x2,x1;
        z1,z2 = z2,z1;
        w1,w2 = w2,w1;
        u1,u2 = u2,u1;
        v1,v2 = v2,v1;
    }
    if y0 > y1 {
        y0,y1 = y1,y0;
        x0,x1 = x1,x0;
        z0,z1 = z1,z0;
        w0,w1 = w1,w0;
        u0,u1 = u1,u0;
        v0,v1 = v1,v1;
    }

    a := Vector4.{xx x0, xx y0, z0, w0};
    b := Vector4.{xx x1, xx y1, z1, w1};
    c := Vector4.{xx x2, xx y2, z2, w2};

    // Upper part
    inv_slope1: float = ifx y1 - y0 != 0 {
        cast(float) (x1 - x0) / abs(cast(float) (y1 - y0));
    } else 0;
    inv_slope2: float = ifx y2 - y0 != 0 {
        cast(float) (x2 - x0) / abs(cast(float) (y2 - y0));
    } else 0;

    if y1 - y0 != 0 {
        for y: y0..y1 {
            x_start: int = xx (x1 + (y - y1) * inv_slope1);
            x_end: int = xx (x0  + (y - y0) * inv_slope2);

            if x_start > x_end {
                x_start, x_end = x_end, x_start;
            }

            for x: x_start..x_end {
                draw_texel(
                    x, y,
                    a, b, c,
                    u0, v0,
                    u1, v1,
                    u2, v2,
                    texture
                );
            }
        }
    }

    // Bottom part
    inv_slope1 = ifx y2 - y1 != 0 {
        cast(float) (x2 - x1) / abs(cast(float) (y2 - y1));
    } else 0;
    inv_slope2 = ifx y2 - y0 != 0 {
        cast(float) (x2 - x0) / abs(cast(float) (y2 - y0));
    } else 0;

    if y2 - y1 != 0 {
        for y: y1..y2 {
            x_start: int = xx (x1 + (y - y1) * inv_slope1);
            x_end: int = xx (x0  + (y - y0) * inv_slope2);

            if x_start > x_end {
                x_start, x_end = x_end, x_start;
            }

            for x: x_start..x_end {
                draw_texel(
                    x, y,
                    a, b, c,
                    u0, v0,
                    u1, v1,
                    u2, v2,
                    texture
                );
            }
        }
    }
}

#scope_file;

draw_flat_bottom :: (x0: int, y0: int, x1: int, y1: int, x2: int, y2: int, color: u32) {
    if cast(float) (y1 - y0) == 0 || cast(float) y2 - y0 == 0 {
        return;
    }

    inv_slope_1 := cast(float) (x1 - x0) / cast(float) (y1 - y0);
    inv_slope_2 := cast(float) (x2 - x0) / cast(float) (y2 - y0);

    x_start: float = xx x0;
    x_end: float = xx x0;

    for y0..y2 {
        draw_line(xx x_start, it, xx x_end, it, color);

        x_start += inv_slope_1;
        x_end += inv_slope_2;
    }
};

draw_flat_top :: (x0: int, y0: int, x1: int, y1: int, x2: int, y2: int, color: u32) {
    if cast(float) (y2 - y0) == 0 || cast(float) (y2 - y1) == 0 {
        return;
    }

    inv_slope_1 := cast(float) (x2 - x0) / cast(float) (y2 - y0);
    inv_slope_2 := cast(float) (x2 - x1) / cast(float) (y2 - y1);

    x_start: float = xx x2;
    x_end: float = xx x2;

    for #v2 < y0..y2 {
        draw_line(xx x_start, it, xx x_end, it, color);

        x_start -= inv_slope_1;
        x_end -= inv_slope_2;
    }
};

set_color_to_buffer :: (col: int, row: int, color: u32) {
    if (
        col > window_width
        || col < 0
        || row > window_height
        || row < 0
    ) {
        return;
    }

    color_buffer[row * window_width + col] = color;
}

clear_color_buffer :: (color: u32) {
    for x: 0..window_width - 1 {
        for y: 0..window_height - 1 {
            set_color_to_buffer(x, y, color);
        }
    }
}

render_color_buffer :: () {
    SDL_UpdateTexture(
        color_buffer_texture,
        null,
        color_buffer,
        size_of(u32) * window_width
    );

    SDL_RenderCopy(
        renderer,
        color_buffer_texture,
        null, null
    );
}

draw_texel :: (
    x: int, y: int,
    a: Vector4, b: Vector4, c: Vector4,
    u0: float, v0: float,
    u1: float, v1: float,
    u2: float, v2: float,
    texture: []u32
) {
    alpha, beta, gamma := barycentric_weights(a.xy, b.xy, c.xy, .{xx x, xx y});

    interpolated_reciprocal_w := 1 / a.w * alpha + 1 / b.w * beta + 1 / c.w * gamma;
    interpolated_u := u0 / a.w * alpha + u1 / b.w * beta + u2 / c.w * gamma;
    interpolated_v := v0 / a.w * alpha + v1 / b.w * beta + v2 / c.w * gamma;
    interpolated_u /= interpolated_reciprocal_w;
    interpolated_v /= interpolated_reciprocal_w;

    texture_x: int = xx abs((interpolated_u * 64));
    texture_y: int = xx abs((interpolated_v * 64));

    color := texture[texture_y * 64 + texture_x];
    draw_pixel(x, y, color);
}

round :: (v: $T) -> int {
    return ifx v < 0.0 {
        cast(int) (v - 0.5);
    }
    else {
        cast(int) (v + 0.5);
    };
}
