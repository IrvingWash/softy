Texture :: struct {
    width:  u32;
    height: u32;
    texels:   [..]u32;
}

Texture_Coordinates :: struct {
    u: float;
    v: float;
}

load :: (data: []u8, width: u32, height: u32) -> Texture {
    texture := Texture.{
        width = width,
        height = height,
    };

    array_resize(*texture.texels, width * height);
    memcpy(texture.texels.data, data.data, data.count);

    return texture;
}

destroy :: (texture: *Texture) {
    array_free(texture.texels);

    texture.* = {};
}



#scope_file

#import "Basic";
