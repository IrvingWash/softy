= World Matrix

A world matrix is a matrix which combines all the different transformation matrices in a single matrix.

It's called "world" matrix, because we work with a mesh given its local coordinates and this matrix transforms these local coordinates to place the mesh in the world

$
mat(
  ;
  "Translatino Matrix";
  ;
  delim: "[",
)

*

mat(
  ;
  "Rotation Matrix";
  ;
  delim: "[",
)

*

mat(
  ;
  "Scale Matrix";
  ;
  delim: "[",
)

*

vec(
  x, y, z, w,
  delim: "[",
)
$

$
mat(
  ;
  "World Matrix";
  ;
  delim: "[",
)

*

vec(
  x, y, z, w,
  delim: "[",
)
$

To get the World Matrix we should:
1. Multiply the Scale Matrix by the Rotation Matrix
2. Multipy the resulting matrix by the Translation Matrix.
Maybe this is true only for row-major matrices. I dont know...
