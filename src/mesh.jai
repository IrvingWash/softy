#import "Basic";
#import "Math";
#import "Text_File_Handler";
#import "String";
#import,file "triangle.jai";

Mesh :: struct {
    // Vertex buffer
    vertices: [..]Vector3;
    // Intex buffer
    faces: [..]Face;
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

    for line: contents {
        if starts_with(line, "v ") {
            data := split(line, " ");
            defer array_free(data);

            array_add(
                *mesh.vertices,
                Vector3.{
                    x = string_to_float(data[1]),
                    y = string_to_float(data[2]),
                    z = string_to_float(data[3]),
                }
            );
        } else if starts_with(line, "f") {
            data := split(line, " ");
            defer array_free(data);

            array_add(
                *mesh.faces,
                Face.{
                    a = to_integer(split(data[1], "/")[0]),
                    b = to_integer(split(data[2], "/")[0]),
                    c = to_integer(split(data[3], "/")[0]),
                }
            );
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
            .{1, 2, 3},
            .{1, 3, 4},
            // Right
            .{4, 3, 5},
            .{4, 5, 6},
            // Back
            .{6, 5, 7},
            .{6, 7, 8},
            // Left
            .{8, 7, 2},
            .{8, 2, 1},
            // Top
            .{2, 7, 5},
            .{2, 5, 3},
            // Bottom
            .{6, 8, 1},
            .{6, 1, 4},
        ]
    );
}
