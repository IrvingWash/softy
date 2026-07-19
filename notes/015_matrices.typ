= Matrices

A matrix is a rectangular arrangement of values into rows and columns.

$
M = mat(
  -2, 5, 6;
  5, 2, 7;
  delim: "[",
)
$

== Matix dimensions

The matrix $M$ is a $2 times 3$ matrix, because it has 2 rows and 3 columns.

== Matrix elements

$
M_(3 times 2) = mat(
  m_(text(fill: std.blue, 1) text(fill: std.green, 1)), m_(text(fill: std.blue, 1) text(fill: std.green, 2));
  m_(text(fill: std.blue, 2) text(fill: std.green, 1)), m_(text(fill: std.blue, 2) text(fill: std.green, 2));
  m_(text(fill: std.blue, 3) text(fill: std.green, 1)), m_(text(fill: std.blue, 3) text(fill: std.green, 2));
  delim: "[",
)
$

A matrix element is referred to as $m_(text(fill: std.blue, "row") text(fill: std.green, "column"))$. (Is this true only for row-major matrices?)
