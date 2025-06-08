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

    for line: contents {
        if starts_with(line, "v ") {
            vertex: Vector3;
            ok := scan2(line, "v % % %", *vertex.x, *vertex.y, *vertex.z);
            if !ok {
                print("Failed to parse vertex coordinates %\n", line, to_standard_error = true);

                return;
            }

            array_add(*mesh.vertices, vertex);
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
            .{1, 2, 3, 0xFFFF0000},
            .{1, 3, 4, 0xFFFF0000},
            // Right
            .{4, 3, 5, 0xFF00FF00},
            .{4, 5, 6, 0xFF00FF00},
            // Back
            .{6, 5, 7, 0xFF0000FF},
            .{6, 7, 8, 0xFF0000FF},
            // Left
            .{8, 7, 2, 0xFFFFFF00},
            .{8, 2, 1, 0xFFFFFF00},
            // Top
            .{2, 7, 5, 0xFFFF00FF},
            .{2, 5, 3, 0xFFFF00FF},
            // Bottom
            .{6, 8, 1, 0xFF00FFFF},
            .{6, 1, 4, 0xFF00FFFF},
        ]
    );
}
