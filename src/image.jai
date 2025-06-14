#import "Basic";
#import "stb_image";

Image :: struct {
    data: []u32;
    width: s32;
    height: s32;
    channels: s32;
}

load_image :: (path: string) -> Image {
    image: Image;

    data := stbi_load(temp_c_string(path), *image.width, *image.height, *image.channels, 0);
    defer stbi_image_free(data);

    image.data = NewArray(image.width * image.channels * image.height, u32, initialized = false);
    memcpy(image.data.data, data, image.width * image.channels * image.height);

    return image;
}

destroy_image :: (image: Image) {
    array_free(image.data);
}
