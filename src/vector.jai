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

// Returns alpha, beta and gamma inside Vector3 using it just as a container.
barycentric_weights :: (a: Vector2, b: Vector2, c: Vector2, p: Vector2) -> Vector3 {
    ac := c - a;
    ab := b - a;
    pc := c - p;
    pb := b - p;
    ap := p - a;

    acab_cross_product_length := ac.x * ab.y - ac.y * ab.x;

    alpha := (pc.x * pb.y - pc.y  * pb.x) / acab_cross_product_length;
    beta := (ac.x * ap.y - ac.y * ap.x) / acab_cross_product_length;
    gamma := 1 - alpha - beta;

    return .{alpha, beta, gamma};
}

operator + :: (a: Vector3, b: $T) -> Vector3 {
    return .{
        a.x + b,
        a.y + b,
        a.z + b,
    };
}

operator - :: (a: Vector3, b: $T) -> Vector3 {
    return .{
        a.x - b,
        a.y - b,
        a.z - b,
    };
}
