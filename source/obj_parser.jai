Obj_Data :: struct {
    vertices: [..]Vector.Vector3;
    faces:    [..]Triangle.Face;
}

parse :: (path: string) -> Obj_Data {
    obj_data: Obj_Data;

    file_content := read_entire_file(path);
    defer free(file_content);

    lines := split(file_content, "\n");
    defer array_free(lines);

    for line: lines {
        if line == "" || starts_with(line, "#") {
            continue;
        }

        // Parse vertex
        if starts_with(line, "v ") {
            vertex: Vector.Vector3;
            scan2(line, "v % % %", *vertex.x, *vertex.y, *vertex.z);
            array_add(*obj_data.vertices, vertex);
        }

        // Parse face
        if starts_with(line, "f ") {
            face: Triangle.Face;
            vertex_indices:  [3]int;
            texture_indices: [3]int;
            normal_indices:  [3]int;

            scan2(
                line,
                "f %/%/% %/%/% %/%/%",
                *vertex_indices[0], *texture_indices[0], *normal_indices[0],
                *vertex_indices[1], *texture_indices[1], *normal_indices[1],
                *vertex_indices[2], *texture_indices[2], *normal_indices[2],
            );

            face.a = vertex_indices[0];
            face.b = vertex_indices[1];
            face.c = vertex_indices[2];

            array_add(*obj_data.faces, face);
        }
    }

    return obj_data;
}

destroy :: (obj_data: *Obj_Data) {
    array_free(obj_data.vertices);
    array_free(obj_data.faces);

    obj_data.* = {};
}



#scope_file

#import "Basic";
#import "File";
#import "String";
Vector   :: #import,file "vector.jai";
Triangle :: #import,file "triangle.jai";
