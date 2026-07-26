Texture :: struct {
    width:  u32;
    height: u32;
    texels:   [..]u32;
}

Texture_Coordinates :: struct {
    u: float;
    v: float;
}

load :: (path: string, flip := false) -> Texture {
    stbi_set_flip_vertically_on_load(xx flip);

    width, height, channel_count: s32;
    image_data := stbi_load(temp_c_string(path), *width, *height, *channel_count, 4);
    assert(image_data != null);
    defer stbi_image_free(image_data);

    texture := Texture.{
        width  = xx width,
        height = xx height,
    };

    array_resize(*texture.texels, width * height);
    memcpy(texture.texels.data, image_data, width * height * channel_count);

    return texture;
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
#import "stb_image";
