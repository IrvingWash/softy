Triangle :: struct {
    points: [3]My_Math.Vector4;

    color: u32;

    average_depth: float;
}

// Indices into a list of vertices which make up a face
Face :: struct {
    a: int;
    b: int;
    c: int;

    color: u32;
}



#scope_file

My_Math :: #import,file "my_math.jai";
