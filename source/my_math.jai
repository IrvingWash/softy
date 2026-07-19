Matrix4 :: struct {
    elements: [4][4]float;
}

Vector2 :: struct {
    x: float;
    y: float;

    #overlay(x) components: [2]float;
}

Vector3 :: struct {
    x: float;
    y: float;
    z: float;

    #overlay(x) components: [3]float;
    #overlay(x) xy:         Vector2;
    #overlay(y) yz:         Vector2;
}

Vector4 :: struct {
    x: float;
    y: float;
    z: float;
    w: float;

    #overlay(x) components: [4]float;
    #overlay(x) xyz:        Vector3;
}

Matrix4_Identity :: Matrix4.{
    elements = [4]float.[
        float.[1, 0, 0, 0],
        float.[0, 1, 0, 0],
        float.[0, 0, 1, 0],
        float.[0, 0, 0, 1],
    ],
};

/*
| 1 0 0 tx |
| 0 1 0 ty |
| 0 0 1 tz |
| 0 0 0  1 |
*/
make_translation_matrix :: (v: Vector3) -> Matrix4 {
    matrix := Matrix4_Identity;

    matrix.elements[0][3] = v.x;
    matrix.elements[1][3] = v.y;
    matrix.elements[2][3] = v.z;

    return matrix;
}

/*
| sx 0  0  0 |
| 0  sy 0  0 |
| 0  0  sz 0 |
| 0  0  0  1 |
*/
make_scale_matrix :: (v: Vector3) -> Matrix4 {
    matrix := Matrix4_Identity;

    matrix.elements[0][0] = v.x;
    matrix.elements[1][1] = v.y;
    matrix.elements[2][2] = v.z;

    return matrix;
}

/*
| c -s 0 0 |
| s  c 0 0 |
| 0  0 1 0 |
| 0  0 0 1 |
*/
make_rotation_around_z_matrix :: (angle: float) -> Matrix4 {
    matrix := Matrix4_Identity;

    c := Math.cos(angle);
    s := Math.sin(angle);

    matrix.elements[0][0] = c;
    matrix.elements[0][1] = -s;
    matrix.elements[1][0] = s;
    matrix.elements[1][1] = c;

    return matrix;
}

/*
| 1 0  0 0 |
| 0 c -s 0 |
| 0 s  c 0 |
| 0 0  0 1 |
*/
make_rotation_around_x_matrix :: (angle: float) -> Matrix4 {
    matrix := Matrix4_Identity;

    c := Math.cos(angle);
    s := Math.sin(angle);

    matrix.elements[1][1] = c;
    matrix.elements[1][2] = -s;
    matrix.elements[2][1] = s;
    matrix.elements[2][2] = c;

    return matrix;
}

/*
|  c 0 s 0 |
|  0 1 0 0 |
| -s 0 c 0 |
|  0 0 0 1 |
*/
make_rotation_around_y_matrix :: (angle: float) -> Matrix4 {
    matrix := Matrix4_Identity;

    c := Math.cos(angle);
    s := Math.sin(angle);

    matrix.elements[0][0] = c;
    matrix.elements[0][2] = s;
    matrix.elements[2][0] = -s;
    matrix.elements[2][2] = c;

    return matrix;
}

add :: (a: Vector3, b: Vector3) -> Vector3 {
    return a + b;
}

add :: (a: *Vector3, b: Vector3) -> Vector3 {
    a += b;
}

operator + :: (a: Vector3, b: Vector3) -> Vector3 {
    return Vector3.{
        a.x + b.x,
        a.y + b.y,
        a.z + b.z,
    };
}

operator += :: (a: *Vector3, b: Vector3) {
    a.x += b.x;
    a.y += b.y;
    a.z += b.z;
}

subtract :: (a: Vector3, b: Vector3) -> Vector3 {
    return a - b;
}

subtract :: (a: *Vector3, b: Vector3) {
    a -= b;
}

operator - :: (a: Vector3, b: Vector3) -> Vector3 {
    return Vector3.{
        a.x - b.x,
        a.y - b.y,
        a.z - b.z,
    };
}

operator -= :: (a: *Vector3, b: Vector3) {
    a.x -= b.x;
    a.y -= b.y;
    a.z -= b.z;
}


multiply :: (a: Vector3, b: float) -> Vector3 {
    return a * b;
}

multiply :: (a: *Vector3, b: float) {
    a *= b;
}

multiply :: (m: Matrix4, v: Vector3) -> Vector4 {
    return m * v;
}

operator * :: (a: Vector3, b: float) -> Vector3 {
    return Vector3.{
        a.x * b,
        a.y * b,
        a.z * b,
    };
}

operator *= :: (a: *Vector3, b: float) -> Vector3 {
    a.x *= b;
    a.y *= b;
    a.z *= b;
}

operator * :: (m: Matrix4, v: Vector3) -> Vector4 {
    result: Vector4;

    result.x = m.elements[0][0] * v.x + m.elements[0][1] * v.y + m.elements[0][2] * v.z + m.elements[0][3];
    result.y = m.elements[1][0] * v.x + m.elements[1][1] * v.y + m.elements[1][2] * v.z + m.elements[1][3];
    result.z = m.elements[2][0] * v.x + m.elements[2][1] * v.y + m.elements[2][2] * v.z + m.elements[2][3];
    result.w = m.elements[3][0] * v.x + m.elements[3][1] * v.y + m.elements[3][2] * v.z + m.elements[3][3];

    return result;
}

divide :: (a: Vector3, b: float) -> Vector3 {
    return a / b;
}

divice :: (a: *Vector3, b: float) {
    a /= b;
}

operator / :: (a: Vector3, b: float) -> Vector3 {
    return Vector3.{
        a.x / b,
        a.y / b,
        a.z / b,
    };
}

operator /= :: (a: *Vector3, b: float) {
    a.x /= b;
    a.y /= b;
    a.z /= b;
}

length :: (v: Vector3) -> float {
    return Math.sqrt(v.x*v.x + v.y*v.y + v.z*v.z);
}

squared_length :: (v: Vector3) -> float {
    return v.x*v.x + v.y*v.y + v.z*v.z;
}

cross :: (a: Vector3, b: Vector3) -> Vector3 {
    return Vector3.{
        a.y * b.z - a.z * b.y,
        a.z * b.x - a.x * b.z,
        a.x * b.y - a.y * b.x,
    };
}

dot :: (a: Vector3, b: Vector3) -> float {
    return a.x * b.x + a.y * b.y + a.z * b.z;
}

normalize :: (v: Vector3) -> Vector3 {
    return v / length(v);
}

normalize :: (v: *Vector3) {
    v / length(v);
}

rotate_around_x :: (vector: Vector3, angle: float) -> Vector3 {
    return Vector3.{
        x = vector.x,
        y = vector.y * Math.cos(angle) - vector.z * Math.sin(angle),
        z = vector.z * Math.cos(angle) + vector.y * Math.sin(angle),
    };
}

rotate_around_x:: (v: *Vector3, angle: float) {
    v.y = v.y * Math.cos(angle) - v.z * Math.sin(angle);
    v.z = v.z * Math.cos(angle) + v.y * Math.sin(angle);
}

rotate_around_y :: (vector: Vector3, angle: float) -> Vector3 {
    return Vector3.{
        x = vector.x * Math.cos(angle) - vector.z * Math.sin(angle),
        y = vector.y,
        z = vector.z * Math.cos(angle) + vector.x * Math.sin(angle),
    };
}

rotate_around_y :: (v: *Vector3, angle: float) {
    v.x = v.x * Math.cos(angle) - v.z * Math.sin(angle);
    v.z = v.z * Math.cos(angle) + v.x * Math.sin(angle);
}

rotate_around_z :: (vector: Vector3, angle: float) -> Vector3 {
    return Vector3.{
        x = vector.x * Math.cos(angle) - vector.y * Math.sin(angle),
        y = vector.y * Math.cos(angle) + vector.x * Math.sin(angle),
        z = vector.z,
    };
}

rotate_around_z :: (v: *Vector3, angle: float) {
    v.x = v.x * Math.cos(angle) - v.y * Math.sin(angle);
    v.y = v.y * Math.cos(angle) + v.x * Math.sin(angle);
}



#scope_file

Math :: #import "Math";
