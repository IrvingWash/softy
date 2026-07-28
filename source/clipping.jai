Frustum_Planes :: enum {
    LEFT;
    RIGHT;
    TOP;
    BOTTOM;
    NEAR;
    FAR;
}

FRUSTUM_PLANES_COUNT :: #run enum_highest_value(Frustum_Planes) + 1;

make_frustum_planes :: (fov: float, z_near: float, z_far: float) -> [FRUSTUM_PLANES_COUNT]My_Math.Plane {
    half_fov := fov / 2;

    cos_half_fov := Math.cos(half_fov);
    sin_half_fov := Math.sin(half_fov);

    result: [FRUSTUM_PLANES_COUNT]My_Math.Plane;

    result[Frustum_Planes.LEFT] = {
        normal = {
            x = cos_half_fov,
            z = sin_half_fov,
        },
    };
    result[Frustum_Planes.RIGHT] = {
        normal = {
            x = -cos_half_fov,
            z = sin_half_fov,
        }
    };
    result[Frustum_Planes.TOP] = {
        normal = {
            y = -cos_half_fov,
            z = sin_half_fov,
        }
    };
    result[Frustum_Planes.BOTTOM] = {
        normal = {
            y = cos_half_fov,
            z = sin_half_fov,
        }
    };
    result[Frustum_Planes.NEAR] = {
        point  = {0, 0, z_near},
        normal = { z = 1 },
    };
    result[Frustum_Planes.FAR] = {
        point  = { 0, 0, z_far },
        normal = { z = -1},
    };

    return result;
}



#scope_file

#import "Basic";
Math    :: #import "Math";
My_Math :: #import,file "my_math.jai";
