= Matrix Operations

== Addition

Only matrices with an equal number of rows and an equal number of columns can be added together, but they don't have to be square matrices.

$
mat(
  m_(1 1), m_(1 2);
  m_(2 1), m_(2 2);
  delim: "[",
)

+

mat(
  n_(1 1), n_(1 2);
  n_(2 1), n_(2 2);
  delim: "[",
)

=

mat(
  m_(1 1) + n_(1 1), m_(1 2) + n_(1 2);
  m_(2 1) + n_(2 1), m_(2 2) + n_(2 2);
  delim: "[",
)
$


$ c_(r c) = a_(r c) + b_(r c) $

$
mat(
  2, 3;
  1, -5;
  delim: "[",
)

+

mat(
  3, 1;
  1, 2;
  delim: "[",
)

=

mat(
  5, 4;
  2, -3;
  delim: "[",
)
$

== Subtraction

$
mat(
  m_(1 1), m_(1 2);
  m_(2 1), m_(2 2);
  delim: "[",
)

-

mat(
  n_(1 1), n_(1 2);
  n_(2 1), n_(2 2);
  delim: "[",
)

=

mat(
  m_(1 1) - n_(1 1), m_(1 2) - n_(1 2);
  m_(2 1) - n_(2 1), m_(2 2) - n_(2 2);
  delim: "[",
)
$


$ c_(r c) = a_(r c) - b_(r c) $

$
mat(
  2, 3;
  1, -5;
  delim: "[",
)

-

mat(
  3, 1;
  1, 2;
  delim: "[",
)

=

mat(
  -1, 2;
  0, -7;
  delim: "[",
)
$

== Multiplication

Only such matrices can be multiplied: $A_(n times m)$ $B_(m times p)$, so only if the number of columns of the left matrix is equalt to the number of rows of the right matrix. (is this applicable only to row-major matrices?)

$
mat(
  m_(1 1), m_(1 2);
  m_(2 1), m_(2 2);
  delim: "[",
)

*

mat(
  n_(1 1), n_(1 2);
  n_(2 1), n_(2 2);
  delim: "[",
)

=

mat(
  (m_(1 1) * n_(1 1) + m_(1 2) * n_(2 1)), (m_(1 1) * n_(1 2) + m_(1 2) * n_(2 2));
  (m_(2 1) * n_(1 1) + m_(2 2) * n_(2 1)), (m_(2 1) * n_(2 1) + m_(2 2) * n_(2 2));
  delim: "[",
)
$

$
c_(r c) = a_r_n * b_c_n + a_r_(n+1) * b_c_(n+1)
$

$
mat(
  1, 2;
  3, 4;
  delim: "[",
)

*

mat(
  5, 6;
  7, 8;
  delim: "[",
)

=

mat(
  (1 * 5 + 2 * 7), (1 * 6 + 2 * 8);
  (3 * 5 + 4 * 7), (3 * 6 + 4 * 8);
  delim: "[",
)
$

=== Matrix multiplication properties

1. The dimensions of the resulting matrix are always known:
$ A_(n times m) * B_(m times p) =  C_(n times p) $

2. Matrix multiplication is not commutative:
$ A * B != B * A $

3. The Identity Matrix is a matrix a multiplication by which produces the original matrix;
$
mat(
  a, b, c;
  d, e, f;
  g, h, i;
  j, k, l;
  delim: "[",
)

*

mat(
  1, 0, 0;
  0, 1, 0;
  0, 0, 1;
  delim: "[",
)

=

mat(
  a, b, c;
  d, e, f;
  g, h, i;
  j, k, l;
  delim: "[",
)
$
The Identity Matrix has $1$s diagonally and $0$ everywhere else
