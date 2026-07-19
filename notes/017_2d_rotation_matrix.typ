= 2D Rotation Matrix

We know how to rotate a vector withot matrices:
$ x' = x cos alpha - y sin alpha $
$ y' = x sin alpha + y cos alpha $

This is how to do the same thing using matrices:
$
mat(
  x';
  y';
  delim: "[",
)

=

mat(
  cos alpha, -sin alpha;
  sin alpha, cos alpha;
  delim: "[",
)

*

mat(
  x;
  y;
  delim: "[",
)

= 

mat(
  x cos alpha - y sin alpha;
  x sin alpha + y cos alpha;
  delim: "[",
)
$

Notice how this whole thin is just putting the formula from the beginning into square brackets.
