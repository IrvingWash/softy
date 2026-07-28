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

// @Todo @Incomplete
clip_polygon_against_plane :: (polygon: *My_Math.Polygon, frustum_plane: My_Math.Plane) {
    inside_vertices:       [My_Math.Polygon.MAX_VERTICES]My_Math.Vector3;
    inside_vertices_count: int;

    // Q_n and Q_n-1
    current_vertex  := *polygon.vertices[0];
    previous_vertex := *polygon.vertices[polygon.vertex_count - 1];

    // How aligned Q_1 and Q_last are with the plane
    dot_current_vertex: float;
    dot_previous_vertex := My_Math.dot(previous_vertex.* - frustum_plane.point, frustum_plane.normal);

    while current_vertex != *polygon.vertices[polygon.vertex_count] {
        dot_current_vertex  = My_Math.dot(current_vertex.* - frustum_plane.point, frustum_plane.normal);

        // We changed from inside to outised or vice-versa
        if dot_current_vertex * dot_previous_vertex < 0 {
            // the "t"
            interpolation_factor := dot_previous_vertex / (dot_previous_vertex - dot_current_vertex);
            intersection_point   := previous_vertex.* + ((current_vertex.* - previous_vertex.*) * interpolation_factor);

            inside_vertices[inside_vertices_count] = intersection_point;
            inside_vertices_count += 1;
        }

        // Vertex is inside the plane
        if dot_current_vertex > 0 {
            inside_vertices[inside_vertices_count] = current_vertex.*;
            inside_vertices_count += 1;
        }

        // Move to the next vertex
        previous_vertex     = current_vertex;
        dot_previous_vertex = dot_current_vertex;
        current_vertex     += 1;
    }

    for i: 0..inside_vertices_count - 1 {
        polygon.vertices[i] = inside_vertices[i];
    }
    polygon.vertex_count = inside_vertices_count;
}

#import "Basic";
Math    :: #import "Math";
My_Math :: #import,file "my_math.jai";

using,only(operator -, operator *, operator +) My_Math;
