#import "Basic";
#import "Math";
#import "Text_File_Handler";
#import "String";
#import,file "triangle.jai";
#import,file "texture.jai";

Mesh :: struct {
    // Vertex buffer
    vertices: [..]Vector3;
    // Intex buffer
    faces: [..]Face;

    translation: Vector3;
    scale: Vector3 = .{1, 1, 1};
    rotation: Vector3;
};

mesh: Mesh;

destroy_mesh :: () {
    array_free(mesh.vertices);
    array_free(mesh.faces);
}

load_obj_data :: (path: string) {
    ok, contents := file_to_array(path);
    if !ok {
        print("Failed to read file %\n", path, to_standard_error = true);

        return;
    }
    defer array_free(contents);

    texture_coordinates: [..]Texture_Coordinates;
    defer array_free(texture_coordinates);

    for line: contents {
        if starts_with(line, "v ") {
            vertex: Vector3;
            ok := scan2(line, "v % % %", *vertex.x, *vertex.y, *vertex.z);
            if !ok {
                print("Failed to parse vertex coordinates %\n", line, to_standard_error = true);

                return;
            }

            array_add(*mesh.vertices, vertex);
        } else if starts_with(line, "vt") {
            coord: Texture_Coordinates;

            ok := scan2(line, "vt % %", *coord.u, *coord.v);
            if !ok {
                print("Failed to parse texture coordinates %\n", line, to_standard_error = true);

                return;
            }

            array_add(*texture_coordinates, coord);
        } else if starts_with(line, "f") {
            face: Face;
            ti: [3]int;
            ni: [3]int;
            ok = scan2(
                line,
                "f %/%/% %/%/% %/%/%",
                *face.a, *ti[0], *ni[0],
                *face.b, *ti[1], *ni[1],
                *face.c, *ti[2], *ni[2]
            );
            if !ok {
                print("Failed to parse face's vertex indexes %\n", line, to_standard_error = true);

                return;
            }

            face.a -= 1;
            face.b -= 1;
            face.c -= 1;
            face.a_uv = texture_coordinates[ti[0] - 1];
            face.b_uv = texture_coordinates[ti[1] - 1];
            face.c_uv = texture_coordinates[ti[2] - 1];

            array_add(*mesh.faces, face);
        }
    }
}

load_cube_mesh_data :: () {
    array_add(
        *mesh.vertices,
        ..Vector3.[
            .{-1, -1, -1}, // 1
            .{-1, 1, -1}, // 2
            .{1, 1, -1}, // 3
            .{1, -1, -1}, // 4
            .{1, 1, 1}, // 5
            .{1, -1, 1}, // 6
            .{-1, 1, 1}, // 7
            .{-1, -1, 1}, // 8
        ]
    );

    array_add(*
        mesh.faces,
        ..Face.[
            // Front
            .{a = 1, b = 2, c = 3, color = 0xFFFFFFFF, a_uv = .{0, 1}, b_uv = .{0, 0}, c_uv = .{1, 0}},
            .{a = 1, b = 3, c = 4, color = 0xFFFFFFFF, a_uv = .{0, 1}, b_uv = .{1, 0}, c_uv = .{1, 1}},
            // Right
            .{a = 4, b = 3, c = 5, color = 0xFFFFFFFF, a_uv = .{0, 1}, b_uv = .{0, 0}, c_uv = .{1, 0}},
            .{a = 4, b = 5, c = 6, color = 0xFFFFFFFF, a_uv = .{0, 1}, b_uv = .{1, 0}, c_uv = .{1, 1}},
            // Back
            .{a = 6, b = 5, c = 7, color = 0xFFFFFFFF, a_uv = .{0, 1}, b_uv = .{0, 0}, c_uv = .{1, 0}},
            .{a = 6, b = 7, c = 8, color = 0xFFFFFFFF, a_uv = .{0, 1}, b_uv = .{1, 0}, c_uv = .{1, 1}},
            // Left
            .{a = 8, b = 7, c = 2, color = 0xFFFFFFFF, a_uv = .{0, 1}, b_uv = .{0, 0}, c_uv = .{1, 0}},
            .{a = 8, b = 2, c = 1, color = 0xFFFFFFFF, a_uv = .{0, 1}, b_uv = .{1, 0}, c_uv = .{1, 1}},
            // Top
            .{a = 2, b = 7, c = 5, color = 0xFFFFFFFF, a_uv = .{0, 1}, b_uv = .{0, 0}, c_uv = .{1, 0}},
            .{a = 2, b = 5, c = 3, color = 0xFFFFFFFF, a_uv = .{0, 1}, b_uv = .{1, 0}, c_uv = .{1, 1}},
            // Bottom
            .{a = 6, b = 8, c = 1, color = 0xFFFFFFFF, a_uv = .{0, 1}, b_uv = .{0, 0}, c_uv = .{1, 0}},
            .{a = 6, b = 1, c = 4, color = 0xFFFFFFFF, a_uv = .{0, 1}, b_uv = .{1, 0}, c_uv = .{1, 1}},
        ]
    );
}
