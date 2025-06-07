#import "Math";

// Stores indices
Face :: struct {
    a: int;
    b: int;
    c: int;
    color: u32;
}

// Stores actual vectors
Triangle :: struct {
    points: [3]Vector2;
    color: u32;
}
