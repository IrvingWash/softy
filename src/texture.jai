#import "Basic";
#import,file "image.jai";

Texture_Coordinates :: struct {
    u: float;
    v: float;
}

texture_width: s32 = 64;
texture_height: s32 = 64;

mesh_texture: []u32;

load_texture :: (path: string) {
    image := load_image(path);

    mesh_texture = image.data;
    texture_width = image.width;
    texture_height = image.height;
}

destroy_texture :: () {
    array_free(mesh_texture);
}
