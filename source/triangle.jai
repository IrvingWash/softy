Triangle :: struct {
    points: [3]Vector.Vector2;

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

Vector :: #import,file "vector.jai";
