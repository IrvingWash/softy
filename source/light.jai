Directional_Light :: struct {
    direction: My_Math.Vector3 = { 0, 0, 1 };
}

apply_light_intensity :: (original_color: u32, factor: float) -> u32 {
    factor = clamp(factor, 0, 1);

    a := (original_color & 0xFF000000);
    r := cast(u32, (original_color & 0x00FF0000) * factor);
    g := cast(u32, (original_color & 0x0000FF00) * factor);
    b := cast(u32, (original_color & 0x000000FF) * factor);

    return a | (r & 0x00FF0000) | (g & 0x0000FF00) | (b & 0x000000FF);
}



#scope_file
