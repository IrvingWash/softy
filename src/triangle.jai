#import "Math";
#import,file "texture.jai";

// Stores indices
Face :: struct {
    a: int;
    b: int;
    c: int;
    a_uv: Texture_Coordinates;
    b_uv: Texture_Coordinates;
    c_uv: Texture_Coordinates;
    color: u32 = 0xFFFFFFFF;
}

// Stores actual vectors
Triangle :: struct {
    points: [3]Vector4;
    texture_coordinates: [3]Texture_Coordinates;
    color: u32 = 0xFFFFFFFF;
    average_depth: float;
}
