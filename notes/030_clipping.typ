= Clipping

Clipping is used to ignore all the vertices that are outside the view frustum.

#figure(
  image("./images/view_frustum.png", height: 30%)
)

The frustum has 6 planes and we clip the geometry against those planes.

The resulting polygon that is produced as the output of one clipping stage is used as an input for the next stage.

== Planes

A plane is defined by point $P$ and a normal vector $arrow(n)$.

#figure(
  image("./images/plane.png", width: 50%),
)

== Finding The Planes

=== Right Frustum Plane

Right frustum plane (top view):
#figure(
  image("./images/right_frustum_plane.png", height: 25%),
)

As said above, the plane is defined by a point $P$ and a normal $arrow(n)$.
Point $P$ is easy to find - it's $(0,0,0)$ (the origin). This works because the plane is infinite.

#figure(
  image("./images/finding_right_plane.png", height: 30%),
)

==== NX
The angle between z axis and the normal is $"fov"/2$.
Using the cosinus of the angle we find this adjacent side:
$ arrow(n)x = -cos("fov"/2) * n p = -cos("fov"/2) $
($n p$ is our $arrow(n)$ so it's length is 1).

==== NY
$ n y = 0 $
Just because it is at the origin

==== NZ
$ n z = sin("fov"/2) * n p = sin("fov" / 2) $

So:
$ P = (0,0,0) $
$ n x = -cos("fov"/2) $
$ n y = 0 $
$ n z = sin("fov"/2) $

=== Left Frustum Plane

$ P = (0,0,0) $
$ n x = -"right"_(n x) = cos("fov"/2) $
$ n y = "right"_(n y) = 0 $
$ n z = "right"_(n z) = sin("fov"/2) $

(We just flipped the triangle to find the values).

=== Top Frustum plane

$ P = (0,0,0) $
$ n x = 0 $
$ n y = -cos("fov"/2) = "right"_(n x) $
$ n z = sin("fov"/2) = "right"_(n z) $

=== Bottom Frustum plane

$ P = (0,0,0) $
$ n x = 0 $
$ n y = cos("fov"/2) = -"right"_(n x) $
$ n z = sin("fov"/2) = "right"_(n z) $

=== Near Frustum Plane
$ P = (0,0,"znear") $
$ n x = 0 $
$ n y = 0 $
$ n z = 1 "(left-handed only)" $

=== Far Frustum Plane
$ P = (0,0,"zfar") $
$ n x = 0 $
$ n y = 0 $
$ n z = -1 "(left-handed only)" $

== Defining Points Inside And Outside Planes

A plane is infinite, thus it separates the 3D space into two half-spaces.
- A point is inside the plane if it's in the half-space into which points the normal.
- A point is outside the plane if it's in the half-space into which points the negative normal.

To determine if a point is inside the plane, we just use the vector dot operation to determine how much the point is aligned with the plane's normal.

#figure(
  image("./images/point_on_plane.png", width: 50%),
)

$Q$ is inside the plane if:
$ (Q - P) dot arrow(n) > 0 $
