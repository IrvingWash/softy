#import "Math";

rotate_around_x :: (v: Vector3, angle: float) -> Vector3 {
    ca := cos(angle);
    sa := sin(angle);

    return .{
        x = v.x,
        y = v.y * ca - v.z * sa,
        z = v.y * sa + v.z * ca,
    };
}

rotate_around_y :: (v: Vector3, angle: float) -> Vector3 {
    ca := cos(angle);
    sa := sin(angle);

    return .{
        x = v.x * ca - v.z * sa,
        y = v.y,
        z = v.x * sa + v.z * ca,
    };
}

rotate_around_z :: (v: Vector3, angle: float) -> Vector3 {
    ca := cos(angle);
    sa := sin(angle);

    return .{
        x = v.x * ca - v.y * sa,
        y = v.x * sa + v.y * ca,
        z = v.z,
    };
}

operator + :: (a: Vector3, b: $T) -> Vector3 {
    return .{
        a.x + b,
        a.y + b,
        a.z + b,
    };
}
