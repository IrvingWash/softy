Mesh :: struct {
    vertices: [..]Vector.Vector3;
    faces:    [..]Triangle.Face;

    rotation: Vector.Vector3;
}

create_mesh :: (vertices: []Vector.Vector3, faces: []Triangle.Face) -> Mesh {
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
Vector :: #import,file "vector.jai";
Triangle :: #import,file "triangle.jai";
