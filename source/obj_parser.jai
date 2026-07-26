Obj_Data :: struct {
    vertices: [..]My_Math.Vector3;
    faces:    [..]Triangle.Face;
}

parse :: (path: string) -> Obj_Data {
    obj_data: Obj_Data;

    file_content := read_entire_file(path);
    defer free(file_content);

    lines := split(file_content, "\n");
    defer array_free(lines);

    normals: [..]My_Math.Vector3;
    uvs:     [..]Texture.Texture_Coordinates;
    defer array_free(normals);
    defer array_free(uvs);

    for line: lines {
        if line == "" || starts_with(line, "#") {
            continue;
        }

        // Parse position
        if starts_with(line, "v ") {
            vertex: My_Math.Vector3;
            scan2(line, "v % % %", *vertex.x, *vertex.y, *vertex.z);
            array_add(*obj_data.vertices, vertex);
        }

        // Parse normal
        if starts_with(line, "vn ") {
            normal: My_Math.Vector3;
            scan2(line, "vn % % %", *normal.x, *normal.y, *normal.z);
            array_add(*normals, normal);
        }

        // Parse uv
        if starts_with(line, "vt ") {
            uv: Texture.Texture_Coordinates;
            scan2(line, "vt % %", *uv.u, *uv.v);
            array_add(*uvs, uv);
        }

        // Parse face
        if starts_with(line, "f ") {
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

            face := Triangle.Face.{
                // Obj's indices start with 1...
                a = vertex_indices[0] - 1,
                b = vertex_indices[1] - 1,
                c = vertex_indices[2] - 1,

                a_uv = uvs[texture_indices[0] - 1],
                b_uv = uvs[texture_indices[1] - 1],
                c_uv = uvs[texture_indices[2] - 1],
            };

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
My_Math  :: #import,file "my_math.jai";
Triangle :: #import,file "triangle.jai";
Texture  :: #import,file "texture.jai";
