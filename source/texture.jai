Texture :: struct {
    width:  u32;
    height: u32;
    data:   [..]u32;
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

    array_resize(*texture.data, data.count);
    for texel: data {
        array_add(*texture.data, texel);
    }

    return texture;
}

destroy :: (texture: *Texture) {
    array_free(texture.data);

    texture.* = {};
}



#scope_file

#import "Basic";
