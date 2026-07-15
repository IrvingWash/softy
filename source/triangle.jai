Triangle :: struct {
    points: [3]Vector.Vector2;
}

// Indices into a list of vertices which make up a face
Face :: struct {
    a: int;
    b: int;
    c: int;
}



#scope_file

Vector :: #import,file "vector.jai";
