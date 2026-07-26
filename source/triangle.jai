Triangle :: struct {
    points: [3]My_Math.Vector4;

    color: u32 = 0xFFFFFFFF;

    uvs: [3]Texture.Texture_Coordinates;

    average_depth: float;
}

// Indices into a list of vertices which make up a face
Face :: struct {
    a: int;
    b: int;
    c: int;

    a_uv: Texture.Texture_Coordinates;
    b_uv: Texture.Texture_Coordinates;
    c_uv: Texture.Texture_Coordinates;

    color: u32 = 0xFFFFFFFF;
}



#scope_file

Texture :: #import,file "texture.jai";
My_Math :: #import,file "my_math.jai";
