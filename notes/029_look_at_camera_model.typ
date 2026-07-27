= Look-at Camera Model

To create a view matrix for a look-at camera, we need the camera's position in world space (the #text(blue)["eye"]) and a point that defines where the camera is looking at (the #text(yellow)["target"]).

== The Look-at Transformation

$M_"view"$ consists of two transformations:
- Translating the whole scene inversly(?) from the camera eye position to the origin (matrix $M_t$).
- Rotating the scene with reverse orientation (matrix $M_r$), so the camera is positioned at the origin and facing the positive z-axis (in left-handed system).

$
M_"view"

=

M_r
*
M_t

=

mat(
  r_(1 1), r_(1 2), r_(1 3), 0;
  r_(2 1), r_(2 2), r_(2 3), 0;
  r_(3 1), r_(3 2), r_(3 3), 0;
  0, 0, 0, 1;
  delim: "[",
)
*
mat(
  1, 0, 0, t_x;
  0, 1, 0, t_y;
  0, 0, 1, t_z;
  0, 0, 0, 1;
  delim: "[",
)
$

$
M_"view"

=

M_r
*
M_t

=

mat(
  r_(1 1), r_(1 2), r_(1 3), (r_(1 1)t_x + r_(1 2)t_y + r_(1 3)t_z);
  r_(2 1), r_(2 2), r_(2 3), (r_(2 1)t_x + r_(2 2)t_y + r_(2 3)t_z);
  r_(3 1), r_(3 2), r_(3 3), (r_(3 1)t_x + r_(3 2)t_y + r_(3 3)t_z);
  0, 0, 0, 1;
  delim: "[",
)
$

=== The Translatino Matrix $M_t$

We simply need to move the camera position to the origin. So in the translation matrix we use negated #text(blue)["eye"] position.

$ M_"view" = M_r * M_t = M_r * mat(1, 0, 0, -"eye"_x; 0, 1, 0, -"eye"_y; 0, 0, 1, -"eye"_z; 0, 0, 0, 1) $

=== The Rotation Matrix $M_r$

For rotation, we must compute #text(blue)[forward(z)], #text(red)[right(x)] and #text(green)[up(y)] vectors.

$
M_r
=
mat(
  #text(std.red)[right(x)]_x, #text(std.green)[up(y)]_x, #text(std.blue)[forward(z)]_x, 0;
  #text(std.red)[right(x)]_y, #text(std.green)[up(y)]_y, #text(std.blue)[forward(z)]_y, 0;
  #text(std.red)[right(x)]_z, #text(std.green)[up(y)]_z, #text(std.blue)[forward(z)]_z, 0;
  0, 0, 0, 1;
  delim: "[",
)
$

This effectively creates converts our coordinate system. But, *the above matrix is not entirely correct*, because it needs to be *inverted*. So we need $M^(-1)_r$.
The matrix should be inverted, because if the camera is to the right of the scene, the scene should be rotated to the left (inversly).


The correct matrix:
$
M_r
=
mat(
  #text(std.red)[right(x)]_x, #text(std.green)[up(y)]_x, #text(std.blue)[forward(z)]_x, 0;
  #text(std.red)[right(x)]_y, #text(std.green)[up(y)]_y, #text(std.blue)[forward(z)]_y, 0;
  #text(std.red)[right(x)]_z, #text(std.green)[up(y)]_z, #text(std.blue)[forward(z)]_z, 0;
  0, 0, 0, 1;
  delim: "[",
)^(-1)
$

Though, we don't need to inverse this matrix by the standard way (which is computationally heavy).
This matrix has properties that let us use a shortcut (it's an orthogonal matrix).
The shortcut is - transposition.
For any orthogonal matrix transposition and inversion give the same result.

$
M_r
=
mat(
  #text(std.red)[right(x)]_x, #text(std.green)[up(y)]_x, #text(std.blue)[forward(z)]_x, 0;
  #text(std.red)[right(x)]_y, #text(std.green)[up(y)]_y, #text(std.blue)[forward(z)]_y, 0;
  #text(std.red)[right(x)]_z, #text(std.green)[up(y)]_z, #text(std.blue)[forward(z)]_z, 0;
  0, 0, 0, 1;
  delim: "[",
)^T
=
mat(
  #text(std.red)[right(x)]_x, #text(std.red)[right(x)]_y, #text(std.red)[right(x)]_z, 0;
  #text(std.green)[up(y)]_x, #text(std.green)[up(y)]_y, #text(std.green)[up(y)]_z, 0;
  #text(std.blue)[forward(z)]_x, #text(std.blue)[forward(z)]_y, #text(std.blue)[forward(z)]_z, 0;
  0, 0, 0, 1;
  delim: "[",
)^T
$

== The Final View Matrix

$ M_"view" = M_r * M_t $

$
M_"view"
=
mat(
  #text(std.red)[right(x)]_x, #text(std.red)[right(x)]_y, #text(std.red)[right(x)]_z, 0;
  #text(std.green)[up(y)]_x, #text(std.green)[up(y)]_y, #text(std.green)[up(y)]_z, 0;
  #text(std.blue)[forward(z)]_x, #text(std.blue)[forward(z)]_y, #text(std.blue)[forward(z)]_z, 0;
  0, 0, 0, 1;
  delim: "[",
)
*
mat(
  1,0,0,-"eye"_x;
  0,1,0,-"eye"_y;
  0,0,1,-"eye"_z;
  0,0,0,0;
  delim: "[",
)
$

The multiplication of the last column happens to be the dot protuct. So at last:
$
M_"view"
=
mat(
  #text(std.red)[right(x)]_x, #text(std.red)[right(x)]_y, #text(std.red)[right(x)]_z, -(#text(std.red)[right(x)] dot "eye");
  #text(std.green)[up(y)]_x, #text(std.green)[up(y)]_y, #text(std.green)[up(y)]_z, -(#text(std.green)[up(y)] dot "eye");
  #text(std.blue)[forward(z)]_x, #text(std.blue)[forward(z)]_y, #text(std.blue)[forward(z)]_z, -(#text(std.blue)[forward(z)] dot "eye");
  0, 0, 0, 1;
  delim: "[",
)
$

==== Matrix inversion

Matrix inversion practically can be applied as "the opposite" operation. Say, we rotated a mesh to the right using $M_r$. If we, after that rotation, use $M^(-1)_r$ on that mesh, it will be rotated back.

=== Matrix transposition

Transposition is very simple - columns become rows, rows become columns. It can be visualized as turning the matrix in 90 degrees.
