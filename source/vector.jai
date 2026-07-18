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

get_length :: (v: Vector3) -> float {
    return Math.sqrt(v.x*v.x + v.y*v.y + v.z*v.z);
}

get_squared_length :: (v: Vector3) -> float {
    return v.x*v.x + v.y*v.y + v.z*v.z;
}

rotate_around_x :: (vector: Vector3, angle: float) -> Vector3 {
    return Vector3.{
        x = vector.x,
        y = vector.y * Math.cos(angle) - vector.z * Math.sin(angle),
        z = vector.z * Math.cos(angle) + vector.y * Math.sin(angle),
    };
}

rotate_around_y :: (vector: Vector3, angle: float) -> Vector3 {
    return Vector3.{
        x = vector.x * Math.cos(angle) - vector.z * Math.sin(angle),
        y = vector.y,
        z = vector.z * Math.cos(angle) + vector.x * Math.sin(angle),
    };
}

rotate_around_z :: (vector: Vector3, angle: float) -> Vector3 {
    return Vector3.{
        x = vector.x * Math.cos(angle) - vector.y * Math.sin(angle),
        y = vector.y * Math.cos(angle) + vector.x * Math.sin(angle),
        z = vector.z,
    };
}



#scope_file

Math :: #import "Math";
