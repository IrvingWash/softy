Camera :: struct {
    position:  My_Math.Vector3;
    direction: My_Math.Vector3 = { 0, 0, 1 };

    forward_velocity: My_Math.Vector3;
    yaw:              float;

    fov: float = Math.PI / 3.0; // 60 degrees in radians,
}
