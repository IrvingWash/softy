= Perspective Projection

To draw a 3D mesh, we need to somehow project points from a 3D world to a 2D screen.

A 3D point has three components - $x y z$.
Because as far as the objects goes from the viewpoint, the more warped it gets, we somehow need to change $x$ and $y$ based on $z$.

To achieve that we use the perspective projection, which is very simple.

== The formulae
Perspective divide:
$
P' = vec(P_x/P_z, P_y/P_z)
$

== Derivation

#import "@preview/cetz:0.5.2"

$P = vec(x = 3, y = 5, z = 7)$ (we must have it)

#cetz.canvas({
  import cetz.draw: *

  // Triangle
  line((0,0), (-7,3), name: "hypotenuse")
  line((-7,3), (-7,0), name: "side_a")
  line((-7,0), (0,0), name: "side_b")

  circle((0,0), name: "vertex_a", radius: 0.01)
  content("vertex_a", text(blue)[$A$], anchor: "south")

  circle((-7,3), name: "vertex_b", radius: 0.01)
  content("vertex_b", text(blue)[$B$], anchor: "south")

  circle((-7,0), name: "vertex_c", radius: 0.01)
  content("vertex_c", text(blue)[$C$], anchor: "north")

  circle((-2, 0.75), name: "vertex_d", radius: 0.01)
  content("vertex_d", text(blue)[$D$], anchor: "south-west")

  circle((-2, 0), name: "vertex_e", radius: 0.01)
  content("vertex_e", text(blue)[$E$], anchor: "south-west")

  // Screen
  line((-2,-3), (-2,3), name: "screen")
  content("screen.start", text[Screen])

  // Eye
  circle((0.3,0), name: "eye", radius: 0.2)
  circle((0.3,0), radius: 0.1, fill: black)

  // Unit line from eye to screen
  line((0,-0.3), (-2,-0.3), mark: (end: "stealth", start: "stealth"), name: "unit_line_from_eye_to_screen")
  content("unit_line_from_eye_to_screen", text[$1$], anchor: "north")

  // P_z line
  line((0,-0.7), (-7,-0.7), mark: (end: "stealth", start: "stealth"), name: "p_z_line")
  content("p_z_line", text[$P_z = 7$], anchor: "north")

  // P_x line
  line((-7.3,3), (-7.3,0), mark: (end: "stealth", start: "stealth"), name: "p_x_line")
  content("p_x_line", text[$P_x = 3$], anchor: "east")

  // Point
  circle((-7, 3), radius: 0.01, name: "point")
  content("point", text(purple)[$P$], anchor: "north-east")

  circle((-2, 0.75), radius: 0.01, name: "point_prime")
  content("point_prime", text(purple)[$P'$], anchor: "north-east")
})

We have the point $P$ in the 3D world, and we need to find $P'$ on the screen.
This is derived using the similar triangles properties which states:
$ (D E)/(B C) = (A E)/(A C) $

The triangles $A B C$ and $A D E$ are similar.

So to find $P'_x$ we have this:
$ P'_x / (B C = P_x = 3) = (A E = 1) / (A C = P_z = 7) $
$ P'_x = P_x / P_z $

The same goes for $y'$:
$ P'_y = P_y / P_z $
