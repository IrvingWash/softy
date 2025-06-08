#import "Basic";
#import "Math";

Light :: struct {
    direction: Vector3;
}

apply_light_intensity :: (original_color: u32, percentage_factor: float) -> u32 {
    clamp(percentage_factor, 0, 1);

    a: u32 = original_color & 0xFF000000;
    r: u32 = xx (cast(float) (original_color & 0x00FF0000) * percentage_factor);
    g: u32 = xx (cast(float) (original_color & 0x0000FF00) * percentage_factor);
    b: u32 = xx (cast(float) (original_color & 0x000000FF) * percentage_factor);

    new_color := a | (r & 0x00FF0000) | (g & 0x0000FF00) | (b & 0x000000FF);

    return new_color;
}
