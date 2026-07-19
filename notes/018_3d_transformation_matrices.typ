= 3D Transformatin Matrices

Usually $4 times 4$ matrices are used to represent 3D transformations.

Though vectors are 3-dimensional, we need a $4 times 4$ matrix, because some transformations (e.g. translation) require an extra row/column.

To enable multiplication between a $4 times 4$ matrix and a 3D vector, we add the fourth component to the vector - $w$.

$
mat(
  m, m, m, m;
  m, m, m, m;
  m, m, m, m;
  m, m, m, m;
  delim: "[",
)

*

vec(
  x, y, z, w,
  delim: "[",
)
$

== Scale Matrix

$
mat(
  s x, 0, 0, 0;
  0, s y, 0, 0;
  0, 0, s z, 0;
  0, 0, 0, 1;
  delim: "[",
)

*

vec(
  x, y, z, 1,
  delim: "[",
)

=

mat(
  s x * x + 0 + 0 + 0;
  0 + s y * y + 0 + 0;
  0 + 0 + s z * z + 0;
  0 + 0 + 0 + 1;
  delim: "[",
)

=

vec(
  s x * x, s y * y, s z * z, 1,
  delim: "[",
)
$

== Translation Matrix

$
mat(
  1, 0, 0, t x;
  0, 1, 0, t y;
  0, 0, 1, t z;
  0, 0, 0, 1;
  delim: "[",
)

*

vec(
  x, y, z, 1,
  delim: "[",
)

=

vec(
  x + t x, y + t y, z + t z, 1,
  delim: "[",
)
$

== Rotation Matrix

=== Around z

$
mat(
  cos(alpha), -sin(alpha), 0, 0;
  sin(alpha), cos(alpha), 0, 0;
  0, 0, 1, 0;
  0, 0, 0, 1;
  delim: "[",
)

*

vec(
  x, y, z, 1,
  delim: "[",
)
$

=== Around x

$
mat(
  1, 0, 0, 0;
  0, cos(alpha), -sin(alpha), 0;
  0, sin(alpha), cos(alpha), 0;
  0, 0, 0, 1;
  delim: "[",
)

*

vec(
  x, y, z, 1,
  delim: "[",
)
$

=== Around y

(We invert here a little bit to keep this rotation counter clockwise, as the others)

$
mat(
  cos(alpha), 0, sin(alpha), 0;
  0, 1, 0, 0;
  -sin(alpha), 0, cos(alpha), 0;
  0, 0, 0, 1;
  delim: "[",
)

*

vec(
  x, y, z, 1,
  delim: "[",
)
$
