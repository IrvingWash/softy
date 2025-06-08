#import "Math";

make_rotation_around_x_matrix4 :: (angle: float) -> Matrix4 {
    sina, cosa := sin_and_cos(angle);

    matrix4 := Matrix4_Identity;
    matrix4._22 = cosa;
    matrix4._23 = -sina;
    matrix4._32 = sina;
    matrix4._33 = cosa;

    return matrix4;
}

make_rotation_around_y_matrix4 :: (angle: float) -> Matrix4 {
    sina, cosa := sin_and_cos(angle);

    matrix4 := Matrix4_Identity;
    matrix4._11 = cosa;
    matrix4._13 = sina;
    matrix4._31 = -sina;
    matrix4._33 = cosa;

    return matrix4;
}

make_rotation_around_z_matrix4 :: (angle: float) -> Matrix4 {
    sina, cosa := sin_and_cos(angle);

    matrix4 := Matrix4_Identity;
    matrix4._11 = cosa;
    matrix4._12 = -sina;
    matrix4._21 = sina;
    matrix4._22 = cosa;

    return matrix4;
}

make_left_handed_perspective_projection_matrix4 :: (fov_angle: float, aspect_inv: float, z_near: float, z_far: float) -> Matrix4 {
    m := Matrix4_Identity;

    fov_factor := 1 / tan(fov_angle / 2);

    lambda_coef := z_far / (z_far - z_near);

    m._11 = aspect_inv * fov_factor;
    m._22 = fov_factor;
    m._33 = lambda_coef;
    m._34 = -lambda_coef * z_near;
    m._43 = 1;

    return m;
}

project_persp :: (matrix: Matrix4, vector: Vector4) -> Vector4 {
    projected := matrix * vector;

    if projected.w != 0 {
        projected.x /= projected.w;
        projected.y /= projected.w;
        projected.z /= projected.w;
    }

    return projected;
}

#scope_file;

sin_and_cos :: (angle: float) -> sina: float, cosa: float {
    return sin(angle), cos(angle);
}
