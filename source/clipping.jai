Frustum_Plane :: enum {
    LEFT;
    RIGHT;
    TOP;
    BOTTOM;
    NEAR;
    FAR;
}

Frustum_Planes :: #type [FRUSTUM_PLANES_COUNT]My_Math.Plane;

clip_polygon :: (polygon: *My_Math.Polygon, frustum_planes: Frustum_Planes) {
    clip_polygon_against_plane(polygon, frustum_planes[Frustum_Plane.LEFT]);
    clip_polygon_against_plane(polygon, frustum_planes[Frustum_Plane.RIGHT]);
    clip_polygon_against_plane(polygon, frustum_planes[Frustum_Plane.TOP]);
    clip_polygon_against_plane(polygon, frustum_planes[Frustum_Plane.BOTTOM]);
    clip_polygon_against_plane(polygon, frustum_planes[Frustum_Plane.NEAR]);
    clip_polygon_against_plane(polygon, frustum_planes[Frustum_Plane.FAR]);
}

make_frustum_planes :: (fov: float, z_near: float, z_far: float) -> Frustum_Planes {
    half_fov := fov / 2;

    cos_half_fov := Math.cos(half_fov);
    sin_half_fov := Math.sin(half_fov);

    result: Frustum_Planes;

    result[Frustum_Plane.LEFT] = {
        normal = {
            x = cos_half_fov,
            z = sin_half_fov,
        },
    };
    result[Frustum_Plane.RIGHT] = {
        normal = {
            x = -cos_half_fov,
            z = sin_half_fov,
        }
    };
    result[Frustum_Plane.TOP] = {
        normal = {
            y = -cos_half_fov,
            z = sin_half_fov,
        }
    };
    result[Frustum_Plane.BOTTOM] = {
        normal = {
            y = cos_half_fov,
            z = sin_half_fov,
        }
    };
    result[Frustum_Plane.NEAR] = {
        point  = {0, 0, z_near},
        normal = { z = 1 },
    };
    result[Frustum_Plane.FAR] = {
        point  = { 0, 0, z_far },
        normal = { z = -1},
    };

    return result;
}



#scope_file

FRUSTUM_PLANES_COUNT :: #run enum_highest_value(Frustum_Plane) + 1;

clip_polygon_against_plane :: (polygon: *My_Math.Polygon, frustum_plane: My_Math.Plane) {
    // @Incomplete
}

#import "Basic";
Math    :: #import "Math";
My_Math :: #import,file "my_math.jai";
