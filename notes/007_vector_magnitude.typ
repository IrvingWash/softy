#import "@preview/cetz:0.5.2"

= Vector magnitude (length)

To find the length of a vector, we just need to use the Pythagorean theorem.

$ "hypotenuse" = sqrt("opposite"^2 + "adjacent"^2) $

#cetz.canvas({
  import cetz.draw: *

 let vector_x = 4
 let vector_y = 3

  line((0,0), (0,5), mark: (end: "stealth"), name: "x_axis");
  line((0,0), (5,0), mark: (end: "stealth"), name: "y_axis");

  line((0,0), (vector_x,vector_y), mark: (end: "stealth"), stroke: red)
  circle((vector_x,vector_y), radius: 0.1, stroke: red, fill: red, name: "point");
  content("point", text(red)[$P_(4, 3)$], anchor: "north-west")

  line((vector_x,0), (vector_x, vector_y), stroke: (paint: green, dash: "dashed"), name: "y_projection");
  content("y_projection", text(green)[3], anchor: "west");

  line((0,-0.1), (vector_x, -0.1), stroke: (paint: green, dash: "dashed"), name: "x_projection")
  content("x_projection", text(green)[4], anchor: "north");
})

So to find the magnitude fo vector $v$ we just need to:
$ ||v|| = sqrt(v_x^2 + v_y^2) $

So for:

$ v = vec(4, 3) $

$ ||v|| = sqrt(4^2 + 3^2) = 5 $
