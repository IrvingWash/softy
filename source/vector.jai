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

get_length :: (v: Vector3) -> float {
    return Math.sqrt(v.x*v.x + v.y*v.y + v.z*v.z);
}

get_squared_length :: (v: Vector3) -> float {
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
