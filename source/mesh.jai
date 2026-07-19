Mesh :: struct {
    vertices: [..]My_Math.Vector3;
    faces:    [..]Triangle.Face;

    translation: My_Math.Vector3;
    scale:       My_Math.Vector3 = { 1, 1, 1 };
    rotation:    My_Math.Vector3;
}

create_mesh :: (vertices: []My_Math.Vector3, faces: []Triangle.Face) -> Mesh {
    mesh: Mesh;

    for vertices {
        array_add(*mesh.vertices, it);
    }

    for faces {
        array_add(*mesh.faces, it);
    }

    return mesh;
}

destroy_mesh :: (mesh: *Mesh) {
    array_free(mesh.vertices);
    array_free(mesh.faces);

    mesh.* = {};
}

#scope_file

#import "Basic";
My_Math :: #import,file "my_math.jai";
Triangle :: #import,file "triangle.jai";
