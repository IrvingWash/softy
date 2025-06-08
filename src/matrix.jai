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

#scope_file;

sin_and_cos :: (angle: float) -> sina: float, cosa: float {
    return sin(angle), cos(angle);
}
