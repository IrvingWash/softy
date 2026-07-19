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
