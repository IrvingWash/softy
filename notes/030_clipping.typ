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

== Finding Intersection Between a Plane And a Line

#let P = text(yellow)[$P$];
#let I = text(purple)[$I$];
#let t = text(blue)[$t$];
#let Q1 = $Q_1$
#let Q2 = $Q_2$
#let normal = text(green)[$arrow(n)$]
#let dotQ1 = text($"dot"_Q_1$)
#let dotQ2 = text($"dot"_Q_2$)

#figure(
  image("./images/plane_line_intersection.png", height: 20%),
)

We need to find #I.

"Linear interpolation equation":
$ #I = #Q1 + #t * (#Q2 - #Q1) $

Where #t is a value between $0$ and $1$. Using this formula we can "walk" over the #Q1#Q2 line and find any point on it.
#t is called "Interpolation factor".
- When #t is $0$, we get #Q1, because $#I = #Q1 + 0 * (#Q2 - #Q1)$
- When #t is $1$, we get #Q2, because $#I = #Q1 + 1 * (#Q2 - #Q1)$

So, to find #I we need to find #t.

$ (#I - #P) = (#Q1 - #P) + #t * ((#Q2 - #P) - (#Q1 - #P)) $
$ #normal dot (#I - #P) = #normal dot (#Q1 - #P) + #t * (#normal dot (#Q2 - #P) - #normal dot (#Q1 - #P)) $
$ #normal dot (#I - #P) = #dotQ1 + #t * (#dotQ2 - #dotQ1) $

#dotQ1 and #dotQ2 are the dot products that we use to find whether a point is inside a plane.

$#normal dot (#I - #P)$ is simply $0$ because it's the dot product between a line *on* the plane and the normal of that plane.

And we get this:
$ 0 = #dotQ1 + #t * (#dotQ2 - #dotQ1) $

$ #t = (-#dotQ1) / (#dotQ2 - #dotQ1) $

$ #t = #dotQ1 / (#dotQ1 - #dotQ2) $

== Clipping a Polygon Against a Plane

#let Qn = $Q_n$
#let Qnext = $Q_(n+1)$

#figure(
  image("./images/polygon_plane_intersection.png", width: 50%),
)

The algorithm:
- Start with any point #Qn
- If #Qn is outside the plane, put it in a list "points outside of the plane"
- Pick #Qnext. If it's now inside the plane, find the intersection of #Qn#Qnext with the plane. Put the intersection point in both lists. Put #Qnext into the list "points inside the plane".

#table(
  columns: (auto, auto),
  align: horizon,
  table.header([*Inside*], [*Outside*]),
  [$I_1$],
  [$Q_1$],
  [$Q_2$],
  [$I_1$],
  [$Q_3$],
  [$I_2$],
  [$Q_4$],
  [$Q_5$],
  [$I_2$],
)

The useful list is the *Inside* list because it contains all the points that we need to draw.

Now the points from the *Inside* list are sent as an input for the test against the next frustum plane and so on.
