#import "Basic"()(MEMORY_DEBUGGER=true);
#import "Math";
#import "SDL";
#import "Sort";
#import,file "image.jai";
#import,file "display.jai";
#import,file "vector.jai";
#import,file "mesh.jai";
#import,file "triangle.jai";
#import,file "matrix.jai";
#import,file "light.jai";
#import,file "texture.jai";

SIMPLE_MODE :: false;

is_running: bool;
previous_frame_time: int; // Milliseconds
triangles_to_render: [..]Triangle;
projection_matrix: Matrix4;
render_mode: Render_Mode;
should_cull_backfaces: bool = true;
sun: Light;

Render_Mode :: enum u8 {
    Wireframe;
    Filled;
    Textured;
    Wireframe_Filled;
    Wireframe_Textured;
}

main :: () {
    sf := *context.print_style.default_format_struct;
    sf.draw_type_name = true;
    sf.use_long_form_if_more_than_this_many_members = 0;
    sf.use_newlines_if_long_form = true;

    display_init();

    setup();

    while is_running {
        process_input();
        update();
        render();
        // memory_visualizer_per_frame_update();
    }

    array_free(triangles_to_render);
    destroy_texture();
    destroy_mesh();
    display_destroy();
}

setup :: () {
    #if SIMPLE_MODE {
        load_cube_mesh_data();
    } else {
        load_obj_data("./assets/cube.obj");
        load_texture("assets/cube.png");
    }

    projection_matrix = make_left_handed_perspective_projection_matrix4(
        fov_angle = 60.0 * PI / 180.0,
        aspect_inv = cast(float) window_height / cast(float) window_width,
        z_near = 0.1, // why
        z_far = 100, // why
    );

    sun = .{
        direction = normalize(Vector3.{
            x = 0,
            y = 0,
            z = 1,
        }),
    };

    is_running = true;
}

process_input :: () {
    event: SDL_Event;
    SDL_PollEvent(*event);

    if event.type == {
        case .SDL_QUIT;
            is_running = false;
        case .SDL_KEYDOWN;
            if event.key.keysym.sym ==  {
                case .SDLK_ESCAPE;
                    is_running = false;
                case .SDLK_1;
                    render_mode = .Wireframe;
                case .SDLK_2;
                    render_mode = .Filled;
                case .SDLK_3;
                    render_mode = .Textured;
                case .SDLK_4;
                    render_mode = .Wireframe_Filled;
                case .SDLK_5;
                    render_mode = .Wireframe_Textured;
                case .SDLK_c;
                    should_cull_backfaces = !should_cull_backfaces;
            }
    }
}

update :: () {
    time_to_wait := FRAME_TARGET_TIME - (SDL_GetTicks() - previous_frame_time);
    if time_to_wait > 0 && time_to_wait <= FRAME_TARGET_TIME {
        SDL_Delay(xx time_to_wait);
    }
    previous_frame_time = SDL_GetTicks();

    // Update the entity
    mesh.scale += Vector3.{};
    mesh.rotation -= Vector3.{0.0, 0.01, 0.0};
    mesh.translation += Vector3.{};
    mesh.translation.z = 5;

    // Prepare for drawing
    // Ugly
    if triangles_to_render.count != 0 {
        array_reset(*triangles_to_render);
    }

    scale_matrix := make_scale_matrix4(mesh.scale);
    translation_matrix := make_translation_matrix4(mesh.translation);
    x_rotation_matrix := make_rotation_around_x_matrix4(mesh.rotation.x);
    y_rotation_matrix := make_rotation_around_y_matrix4(mesh.rotation.y);
    z_rotation_matrix := make_rotation_around_z_matrix4(mesh.rotation.z);
    world_matrix := scale_matrix * Matrix4_Identity;
    world_matrix = z_rotation_matrix * world_matrix;
    world_matrix = y_rotation_matrix * world_matrix;
    world_matrix = x_rotation_matrix * world_matrix;
    world_matrix = translation_matrix * world_matrix;

    // Make triangles to render
    for face: mesh.faces {
        face_vertices: [3]Vector3 = .[
            mesh.vertices[face.a],
            mesh.vertices[face.b],
            mesh.vertices[face.c],
        ];

        // Transform
        triangle_transformed_vertices: [3]Vector4;
        for vertex: face_vertices {
            transformed := world_matrix * make_vector4(vertex, 1);

            // Store to pass to projection phaze
            triangle_transformed_vertices[it_index] = transformed;
        }

        // Cull backfaces
        if should_cull_backfaces {
            v_a := triangle_transformed_vertices[0].xyz;
            v_b := triangle_transformed_vertices[1].xyz;
            v_c := triangle_transformed_vertices[2].xyz;

            // No need to normalize at this point.
            v_ab := normalize(v_b - v_a);
            // No need to normalize at this point.
            v_ac := normalize(v_c - v_a);

            // No need to normalize at this point.
            normal := normalize(cross_product(v_ab, v_ac));

            view_point_ray := Vector3.{0,0,0} - v_a;

            normal_and_view_point_alignment := dot_product(normal, view_point_ray);

            if normal_and_view_point_alignment < 0 {
                // Don't project and don't store in triangles_to_render
                continue;
            }
        }

        // Shade
        shaded_color: u32 = ---;
        {
            // @Copy_and_paste from the culling section above
            v_a := triangle_transformed_vertices[0].xyz;
            v_b := triangle_transformed_vertices[1].xyz;
            v_c := triangle_transformed_vertices[2].xyz;

            v_ab := normalize(v_b - v_a);
            v_ac := normalize(v_c - v_a);

            normal := normalize(cross_product(v_ab, v_ac));

            normal_and_sun_ray_alignment := -dot_product(normal, sun.direction);

            shaded_color = apply_light_intensity(face.color, normal_and_sun_ray_alignment);
        }

        // Project
        processed_triangle: Triangle = .{
            color = shaded_color,
            average_depth = (
                triangle_transformed_vertices[0].z
                + triangle_transformed_vertices[1].z
                + triangle_transformed_vertices[2].z
            ) / 3,
            texture_coordinates = .[face.a_uv, face.b_uv, face.c_uv],
        };
        for vertex: triangle_transformed_vertices {
            projected := project_persp(projection_matrix, vertex);

            // Scale (why here and not in the Transform phaze above?..)
            projected.x *= window_width / 2.0;
            projected.y *= window_height / 2.0;

            // Invert to account for flipped y and x in our screen
            // projected.x *= -1;
            projected.y *= -1;

            // Tanslate (why here and not in the Transform phaze above?..)
            projected.x += window_width / 2.0;
            projected.y += window_height / 2.0;

            // Store finalized vertices that will be rendered
            processed_triangle.points[it_index] = projected;
        }

        array_add(*triangles_to_render, processed_triangle);
    }
}

render :: () {
    quick_sort(triangles_to_render, (a, b) => b.average_depth - a.average_depth);

    start_drawing();

    for triangle: triangles_to_render {
        if render_mode == {
            case .Filled; #through;
            case .Wireframe_Filled;
                draw_triangle_filled(
                    xx triangle.points[0].x,
                    xx triangle.points[0].y,
                    xx triangle.points[1].x,
                    xx triangle.points[1].y,
                    xx triangle.points[2].x,
                    xx triangle.points[2].y,
                    triangle.color,
                );
        }

        if render_mode == {
            case .Textured; #through;
            case .Wireframe_Textured;
                draw_triangle_textured(
                    xx triangle.points[0].x,
                    xx triangle.points[0].y,
                    xx triangle.points[0].z,
                    xx triangle.points[0].w,
                    triangle.texture_coordinates[0].u,
                    triangle.texture_coordinates[0].v,
                    xx triangle.points[1].x,
                    xx triangle.points[1].y,
                    xx triangle.points[1].z,
                    xx triangle.points[1].w,
                    triangle.texture_coordinates[1].u,
                    triangle.texture_coordinates[1].v,
                    xx triangle.points[2].x,
                    xx triangle.points[2].y,
                    xx triangle.points[2].z,
                    xx triangle.points[2].w,
                    triangle.texture_coordinates[2].u,
                    triangle.texture_coordinates[2].v,
                    mesh_texture,
                );
        }

        if render_mode == {
            case .Wireframe; #through;
            case .Wireframe_Textured; #through;
            case .Wireframe_Filled;
                draw_triangle(
                    xx triangle.points[0].x,
                    xx triangle.points[0].y,
                    xx triangle.points[1].x,
                    xx triangle.points[1].y,
                    xx triangle.points[2].x,
                    xx triangle.points[2].y,
                    0xFFEEEEEE,
                );
        }
    }

    finish_drawing();
}
