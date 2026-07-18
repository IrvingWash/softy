#import "@preview/cetz:0.5.2"

= Trianlge Rasterization

== Flat-top & Flat-bottom Technique

#cetz.canvas({
  import cetz.draw: *

  polygon(
    (0,0),
    3,
    angle: 0deg,
    stroke: blue,
    fill: blue,
    name: "triangle",
  );
  line(
    (-0.5,0),
    (1,0),
    stroke: red,
    name: "divider",
  )
})

=== 1. We divide the triangle in half, so we get two triangles: one with a flat bottom and one with a flat top.
To divide the triangle in half we need to sort our vertices by the $y$ coordinate. Because we want to go from top to bottom, but if the triangle is rotated, we don't know which vertex is at the top.

Given our coordinate system stards at the top left corner, we need to sort like this:
$ y_0 < y_1 < y_2 $

So regardless of the original vertex vertical sequence, we will get this after sorting:
#cetz.canvas({
  import cetz.draw: *

  polygon(
    (0,0),
    3,
    angle: 0deg,
    stroke: blue,
    fill: blue,
    name: "triangle",
  );

  circle((-0.5,0.9), radius: 0.1, name: "y_0")
  content("y_0", text[($x_0, y_0$)], anchor: "south-east")

  circle((1,0), radius: 0.1, name: "y_1")
  content("y_1", text[($x_1, y_1$)], anchor: "south-west")

  circle((-0.5,-0.9), radius: 0.1, name: "y_2")
  content("y_2", text[($x_2, y_2$)], anchor: "north-west")
})

=== 2. We need to find the point at which the dividing line ends - $M$
#cetz.canvas({
  import cetz.draw: *

  polygon(
    (0,0),
    3,
    angle: 0deg,
    stroke: blue,
    fill: blue,
    name: "triangle",
  );

  line(
    (-0.5,0),
    (1,0),
    stroke: red,
    name: "divider",
  )

  circle((-0.5,0.9), radius: 0.1, name: "y_0")
  content("y_0", text[($x_0, y_0$)], anchor: "south-east")

  circle((1,0), radius: 0.1, name: "y_1")
  content("y_1", text[($x_1, y_1$)], anchor: "south-west")

  circle((-0.5,-0.9), radius: 0.1, name: "y_2")
  content("y_2", text[($x_2, y_2$)], anchor: "north-west")

  circle((-0.5,0), radius: 0.1, name: "M_y")
  content("M_y", text[($M x_1, M y_1$)], anchor: "south-east")
})

$M_y = y_1$ naturally.

The $M_x$ formula is derived using the similar triangles properties. Unfortunatelly I can't depict that because cetz fucking sucks ass:
$
(M_x - x_0) / (x_2 - x_0) = (y_1 - y_0) / (y_2 - y_0)
$
(We substituted $M_y$ with $y_1$ here)

$
M_x = ((x_2 - x_0)(y_1 - y_0))/(y_2 - y_0) + x_0
$

=== 3. Flat-bottom fill algorithm
A flat-bottom triangle has two slopes - left and right (the two sides).
1. We start from the top $(x_0,y_0)$
2. Calculate the two slopes: $(x_1 - x_0) / (y_1 - y_0)$ and $(x_2 - x_0) / (y_2 - y_0)$. These are inverse slopes, because we move vertically.
3. Loop all the "scanlines" from $y_0$ to $y_2$
3.1. Calculate `x_start` and `x_end`. These are the points where the slopes are on the currenct scanline
3.2. Loop between `x_start` and `x_end` and fill the line

=== 4. Flat-top fill algorithm
It's the same, but we loop from the botttom to the top (the divider)
