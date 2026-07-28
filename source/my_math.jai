Plane :: struct {
    point:  Vector3;
    normal: Vector3;
}

Polygon :: struct {
    vertices:     [MAX_VERTICES]Vector3;
    vertex_count: int;

    MAX_VERTICES :: 10;
}

// Column-vectors
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
    #overlay(x) xy:         Vector2;
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

operator - :: (a: Vector2, b: Vector2) -> Vector2 {
    return Vector2.{
        a.x - b.x,
        a.y - b.y,
    };
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

multiply :: (a: Matrix4, b: Matrix4) -> Matrix4 {
    return a * b;
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

operator * :: (m: Matrix4, v: Vector4) -> Vector4 {
    result: Vector4;

    result.x = m.elements[0][0] * v.x + m.elements[0][1] * v.y + m.elements[0][2] * v.z + m.elements[0][3] * v.w;
    result.y = m.elements[1][0] * v.x + m.elements[1][1] * v.y + m.elements[1][2] * v.z + m.elements[1][3] * v.w;
    result.z = m.elements[2][0] * v.x + m.elements[2][1] * v.y + m.elements[2][2] * v.z + m.elements[2][3] * v.w;
    result.w = m.elements[3][0] * v.x + m.elements[3][1] * v.y + m.elements[3][2] * v.z + m.elements[3][3] * v.w;

    return result;
}

operator * :: (a: Matrix4, b: Matrix4) -> Matrix4 {
    result := Matrix4_Identity;

    for i: 0..3 {
        for j: 0..3 {
            result.elements[i][j] = a.elements[i][0] * b.elements[0][j]
                + a.elements[i][1] * b.elements[1][j]
                + a.elements[i][2] * b.elements[2][j]
                + a.elements[i][3] * b.elements[3][j];
        }
    }

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

cross :: (a: Vector2, b: Vector2) -> float {
    return a.x * b.y - a.y * b.x;
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

/*
| (height/width) * 1 / tan(fov/2) |        0       |             0            |                   0                  |
|                 0               | 1 / tan(fov/2) |             0            |                   0                  |
|                 0               |        0       | z_far / (z_far - z_near) | -(z_far / (z_far - z_near)) * z_near |
|                 0               |        0       |             1            |                   0                  |

z is normalized between 0 to 1
Left-handed
*/
make_perspective_projection_matrix :: (
    aspect_ratio_vertical_over_horizontal: float,
    fov_in_radians:                        float,
    z_near:                                float,
    z_far:                                 float,
) -> Matrix4 {
    matrix: Matrix4;

    fov_factor := 1.0 / Math.tan(fov_in_radians / 2.0);

    matrix.elements[0][0] = aspect_ratio_vertical_over_horizontal * fov_factor;
    matrix.elements[1][1] = fov_factor;

    z_scale       := z_far / (z_far - z_near);
    z_translation := -z_scale * z_near;

    matrix.elements[2][2] = z_scale;
    matrix.elements[2][3] = z_translation;

    // To keep the z value in the w component
    matrix.elements[3][2] = 1;

    return matrix;
}

project_vector_perspective :: (matrix: Matrix4, vector: Vector4) -> Vector4 {
    result := matrix * vector;

    if result.w != 0 {
        result.x /= result.w;
        result.y /= result.w;
        result.z /= result.w;
    }

    return result;
}

round :: (value: $T, $R: Type = int) -> R
#modify {
    return IsScalar(T);
}
{
    if value > 0 {
        return cast(R, value + 0.5);
    } else {
        return cast(R, value - 0.5);
    }
}

calculate_barycentric_weights :: (a: Vector2, b: Vector2, c: Vector2, p: Vector2) -> alpha: float, beta: float, gamma: float {
    ac := c - a;
    ab := b - a;
    pc := c - p;
    pb := b - p;
    ap := p - a;

    doubled_triangle_area := cross(ac, ab); // Because these are 2D vectors, the cross product is already the length.

    alpha := cross(pc, pb) / doubled_triangle_area;
    beta  := cross(ac, ap) / doubled_triangle_area;
    gamma := 1.0 - alpha - beta;

    return alpha, beta, gamma;
}

// | x.x, x.y, x.z, -dot(x,eye) | //
// | y.x, y.y, y.z, -dot(y,eye) | //
// | z.x, z.y, z.z, -dot(z,eye) | //
// |  0    0    0        1      | //
// Left-handed
make_look_at_matrix :: (eye: Vector3, target: Vector3, world_up: Vector3) -> Matrix4 {
    z := normalize(target - eye);       // Vector pointing from eye to target
    x := normalize(cross(world_up, z)); // Perpendicular vector to world_up and z
    y := cross(z, x);                   // Perpendicular vector to z and x

    matrix := Matrix4_Identity;

    matrix.elements[0][0] = x.x;
    matrix.elements[0][1] = x.y;
    matrix.elements[0][2] = x.z;
    matrix.elements[0][3] = -dot(x, eye);

    matrix.elements[1][0] = y.x;
    matrix.elements[1][1] = y.y;
    matrix.elements[1][2] = y.z;
    matrix.elements[1][3] = -dot(y, eye);

    matrix.elements[2][0] = z.x;
    matrix.elements[2][1] = z.y;
    matrix.elements[2][2] = z.z;
    matrix.elements[2][3] = -dot(z, eye);

    return matrix;
}

create_polygon :: (vertices: ..Vector3) -> Polygon {
    assert(vertices.count <= Polygon.MAX_VERTICES, "To many vertices, Polygon can hold only %", Polygon.MAX_VERTICES);

    polygon := Polygon.{
        vertex_count = vertices.count,
    };

    for vertex: vertices {
        polygon.vertices[it_index] = vertex;
    }

    return polygon;
}



#scope_file

#import "Basic";
Math :: #import "Math";
