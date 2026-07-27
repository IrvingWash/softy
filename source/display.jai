window_width:  s32 = 800;
window_height: s32 = 600;

window:   *SDL_Window;
renderer: *SDL_Renderer;

color_buffer: [..]u32;
color_buffer_texture: *SDL_Texture;
z_buffer: [..]float;

init :: () {
    init_window();

    array_resize(*color_buffer, window_width * window_height);
    array_resize(*z_buffer, window_width * window_height);

    SDL_PIXELFORMAT_ARGB8888 :: 0x16362004;
    SDL_PIXELFORMAT_RGBA8888 :: 0x16462004;
    SDL_PIXELFORMAT_ABGR8888 :: 0x16762004;
    color_buffer_texture = SDL_CreateTexture(
        renderer,
        SDL_PIXELFORMAT_ABGR8888,
        xx SDL_TextureAccess.STREAMING,
        window_width,
        window_height,
    );
}

deinit :: () {
    array_free(z_buffer);

    SDL_DestroyTexture(color_buffer_texture);
    array_free(color_buffer);

    destroy_window();
}

start_drawing :: () {
    clear_color_buffer(0xFF000000);
    clear_z_buffer();
}

finish_drawing :: () {
    render_color_buffer();

    SDL_RenderPresent(renderer);
}

draw_filled_rectangle :: (x: s32, y: s32, width: s32, height: s32, color: u32) {
    for w: 0..width - 1 {
        for h: 0..height - 1 {
            cx := x + w;
            cy := y + h;

            draw_pixel(cx, cy, color);
        }
    }
}

draw_triangle :: (
    x0: s32, y0: s32,
    x1: s32, y1: s32,
    x2: s32, y2: s32,
    color: u32,
) {
    draw_line(x0, y0, x1, y1, color);
    draw_line(x1, y1, x2, y2, color);
    draw_line(x2, y2, x0, y0, color);
}

// We draw filled triangles using the flat-bottom & flat-top technique
draw_filled_triangle :: (
    x0: s32, y0: s32,
    x1: s32, y1: s32,
    x2: s32, y2: s32,
    color: u32,
) {
    // Sort vertices so y0 is always the the top one, y1 is always the middle one, y2 is always the bottom one.
    // We need to know exactly where each vertex is vertically.
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

    // The triangle is already flat-bottom
    if y1 == y2 {
        draw_flat_bottom_triangle(x0, y0, x1, y1, x2, y2, color);
        return;
    }

    // The triangle is already flat-top
    if y0 == y1 {
        draw_flat_top_triangle(x0, y0, x1, y1, x2, y2, color);
        return;
    }

    // The triangle is neither flat-bottom nor flat-top

    // Find the other end of the middle separator (the first end is x1 y1)
    My := y1;
    Mx := cast(float, (x2 - x0) * (y1 - y0)) / cast(float, y2 - y0) + x0;

    // Draw flat-bottom triangle
    draw_flat_bottom_triangle(x0, y0, x1, y1, xx Mx, My, color);

    // Draw flat-top triangle
    draw_flat_top_triangle(x1, y1, xx Mx, My, x2, y2, color);
}

draw_textured_triangle :: (
    x0: s32, y0: s32, z0: float, w0: float, u0: float, v0: float,
    x1: s32, y1: s32, z1: float, w1: float, u1: float, v1: float,
    x2: s32, y2: s32, z2: float, w2: float, u2: float, v2: float,
    texture: Texture.Texture,
) {
    // Sort vertices so y0 is always the the top one, y1 is always the middle one, y2 is always the bottom one.
    // We need to know exactly where each vertex is vertically.
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
        v0,v1 = v1,v0;
    }

    // Render the upper part of the triangle (the flat-bottom part)
    // It's inverse, because the slope is how much y changes for each x, but in this case we want the opposite - how much x changes for each y
    if y1 - y0 != 0 {
        left_inverse_slope, right_inverse_slope: float;

        if y1 - y0 != 0 then left_inverse_slope = cast(float, x1 - x0) / Math.abs(cast(float, y1 - y0));
        if y2 - y0 != 0 then right_inverse_slope = cast(float, x2 - x0) / Math.abs(cast(float, y2 - y0));

        for y: y0..y1 {
            x_start := x1 + (y - y1) * left_inverse_slope;
            x_end   := x0 + (y - y0) * right_inverse_slope;
            if x_end < x_start {
                x_start,x_end = x_end, x_start;
            }

            for x: cast(s32, x_start)..cast(s32, x_end)-1 {
                draw_texel(
                    x, y,
                    { xx x0, xx y0, z0, w0 },
                    { xx x1, xx y1, z1, w1 },
                    { xx x2, xx y2, z2, w2 },
                    { u0, v0 },
                    { u1, v1 },
                    { u2, v2 },
                    texture,
                );
            }
        }
    }

    // Render the lower part of the triangle (the flat-top part)
    if y2 - y1 != 0 {
        left_inverse_slope, right_inverse_slope: float;

        if y2 - y1 != 0 then left_inverse_slope = cast(float, x2 - x1) / Math.abs(cast(float, y2 - y1));
        if y2 - y0 != 0 then right_inverse_slope = cast(float, x2 - x0) / Math.abs(cast(float, y2 - y0));

        for y: y1..y2 {
            x_start := x1 + (y - y1) * left_inverse_slope;
            x_end   := x0 + (y - y0) * right_inverse_slope;
            if x_end < x_start {
                x_start, x_end = x_end, x_start;
            }

            for x: cast(s32, x_start)..cast(s32, x_end)-1 {
                draw_texel(
                    x, y,
                    { xx x0, xx y0, z0, w0 },
                    { xx x1, xx y1, z1, w1 },
                    { xx x2, xx y2, z2, w2 },
                    { u0, v0 },
                    { u1, v1 },
                    { u2, v2 },
                    texture,
                );
            }
        }
    }
}

draw_line :: (x0: s32, y0: s32, x1: s32, y1: s32, color: u32) {
    delta_x := x1 - x0;
    delta_y := y1 - y0;

    longest_side_length := ifx Math.abs(delta_x) >= Math.abs(delta_y)
        then Math.abs(delta_x)
        else Math.abs(delta_y);

    x_step: float = cast(float, delta_x) / cast(float, longest_side_length);
    y_step: float = cast(float, delta_y) / cast(float, longest_side_length);

    current_x: float = cast(float, x0);
    current_y: float = cast(float, y0);

    for 0..longest_side_length {
        draw_pixel(My_Math.round(current_x, s32), My_Math.round(current_y, s32), color);

        current_x += x_step;
        current_y += y_step;
    }
}

draw_grid :: (grid_color: u32, grid_size: s32) {
    for y: 0..window_height - 1 {
        for x: 0..window_width - 1 {
            if x % grid_size == 0 || y % grid_size == 0 {
                draw_pixel(xx x, xx y, grid_color);
            }
        }
    }
}

draw_pixel :: (x: s32, y: s32, color: u32) {
    if (
        x >= 0 && x < window_width
        && y >= 0 && y < window_height
    ) {
        color_buffer[y * xx window_width + x] = color;
    }
}



#scope_file

// This is super bad because we calculate the same things here again and again for each fragment in a triangle, but the triangle can't change while we are in "draw_textured_triangle"!
draw_texel :: (
    x: s32, y: s32,
    a: My_Math.Vector4,
    b: My_Math.Vector4,
    c: My_Math.Vector4,
    a_uv: Texture.Texture_Coordinates,
    b_uv: Texture.Texture_Coordinates,
    c_uv: Texture.Texture_Coordinates,
    texture: Texture.Texture,
) {
    alpha, beta, gamma := My_Math.calculate_barycentric_weights(a.xy, b.xy, c.xy, { xx x, xx y });

    interpolated_reciprocal_w := 1  / a.w * alpha + 1  / b.w * beta + 1  / c.w * gamma;

    if interpolated_reciprocal_w < z_buffer[y * window_width + x] {
        return;
    }

    interpolated_u: float;
    interpolated_v: float;
    {
        interpolated_u = (a_uv.u / a.w * alpha + b_uv.u / b.w * beta + c_uv.u / c.w * gamma) / interpolated_reciprocal_w;
        interpolated_v = (a_uv.v / a.w * alpha + b_uv.v / b.w * beta + c_uv.v / c.w * gamma) / interpolated_reciprocal_w;
    }

    texel_x := Math.abs(cast(int, interpolated_u * texture.width));
    texel_y := Math.abs(cast(int, interpolated_v * texture.height));

    index := texture.width * texel_y + texel_x;
    if index > texture.texels.count - 1{
        return;
    }

    color := texture.texels[index];

    draw_pixel(x, y, color);

    z_buffer[y * window_width + x] = interpolated_reciprocal_w;
}


draw_flat_bottom_triangle :: (
    x0: int, y0: int,
    x1: int, y1: int,
    x2: int, y2: int,
    color: u32,
) {
    if y1 - y0 == 0 || y2 - y0 == 0 {
        return;
    }

    inv_slope_1 := cast(float, x1 - x0) / cast(float, y1 - y0);
    inv_slope_2 := cast(float, x2 - x0) / cast(float, y2 - y0);

    x_start: float = xx x0;
    x_end:   float = xx x0;
    for y: y0..y2 {
        draw_line(xx x_start, xx y, xx x_end, xx y, color);

        x_start += inv_slope_1;
        x_end   += inv_slope_2;
    }
};

draw_flat_top_triangle :: (
    x0: int, y0: int,
    x1: int, y1: int,
    x2: int, y2: int,
    color: u32,
) {
    if y2 - y0 == 0 || y2 - y1 == 0 {
        return;
    }

    inv_slope_1 := cast(float, x2 - x0) / cast(float, y2 - y0);
    inv_slope_2 := cast(float, x2 - x1) / cast(float, y2 - y1);

    x_start: float = xx x2;
    x_end:   float = xx x2;

    for < y: y0..y2 {
        draw_line(xx x_start, xx y, xx x_end, xx y, color);

        x_start -= inv_slope_1;
        x_end   -= inv_slope_2;
    }
};

init_window :: () {
    result := SDL_Init(SDL_INIT_VIDEO);
    assert(result == 0, "Failed to initialize SDL");

    display_mode: SDL_DisplayMode;
    SDL_GetCurrentDisplayMode(0, *display_mode);
    window_width  = display_mode.w;
    window_height = display_mode.h;

    window = SDL_CreateWindow(
        "Softy",
        SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED,
        xx window_width,
        xx window_height,
        SDL_WINDOW_BORDERLESS,
    );
    assert(window != null, "Failed to create SDL window");

    SDL_SetWindowFullscreen(window, xx SDL_WINDOW_FULLSCREEN);

    renderer = SDL_CreateRenderer(window, -1, 0);
    assert(renderer != null, "Failed to create SDL renderer");
}

destroy_window :: () {
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
}

render_color_buffer :: () {
    SDL_UpdateTexture(
        color_buffer_texture,
        null,
        color_buffer.data,
        window_width * size_of(u32),
    );

    SDL_RenderCopy(
        renderer,
        color_buffer_texture,
        null,
        null,
    );
}

clear_color_buffer :: (clear_color: u32) {
    for *color: color_buffer {
        color.* = clear_color;
    }
}

clear_z_buffer :: () {
    for *depth: z_buffer {
        depth.* = 0;
    }
}

#import "Basic";
#import "SDL";
Math :: #import "Math";
Texture :: #import,file "texture.jai";
My_Math :: #import,file("my_math.jai");
