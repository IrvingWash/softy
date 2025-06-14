#import,file "image.jai";

Texture_Coordinates :: struct {
    u: float;
    v: float;
}

texture_width: s32 = 64;
texture_height: s32 = 64;

mesh_texture: []u32;

load_texture :: (path: string) {
    mesh_texture = load_image(path).data;
}
