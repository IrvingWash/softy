#import "@preview/cetz:0.5.2"

= Finding the Normal Vector of a Triangle Face

#cetz.canvas({
  import cetz.draw: *

  let a_x = 4
  let a_y = 2

  let b_x = 2
  let b_y = -2

  let c_x = 0
  let c_y = 0

  let point_radius = 0.1

  circle((a_x,a_y), radius: point_radius, name: "a")
  content("a", text[$A$], anchor: "west")

  circle((b_x,b_y), radius: point_radius, name: "b")
  content("b", text[$B$], anchor: "north-west")

  circle((c_x,c_y), radius: point_radius, name: "c")
  content("c", text[$C$], anchor: "north-east")

  line(
    (a_x,a_y),
    (c_x,c_y),
    name: "a_c",
    mark: (end: "stealth"),
    stroke: green,
  )

  line(
    (c_x,c_y),
    (b_x,b_y),
    name: "c_b",
  )

  line(
    (a_x,a_y),
    (b_x,b_y),
    name: "a_b",
    mark: (end: "stealth"),
    stroke: green,
  )

  line(
    (a_x,a_y),
    (3.5, 3),
    mark: (end: "stealth"),
    stroke: red,
    name: "normal"
  )
  content("normal.end", text(red)[$N$])
})

$ N = (B - A) times (C - A) $

We have vectors $A$ $B$ and $C$ which make up the vertices of the triangle, not the sides.

So we need to wind the vectors that make the sides so we can calculate the cross product to get the $N$ vector.
