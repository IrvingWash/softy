#import "Basic";
#import "Math";
#import,file "triangle.jai";

Mesh :: struct {
    vertices: [..]Vector3;
    faces: [..]Face;
    rotation: Vector3;
};

mesh: Mesh;

destroy_mesh :: () {
    array_free(mesh.vertices);
    array_free(mesh.faces);
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

