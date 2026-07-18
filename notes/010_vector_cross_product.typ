#import "@preview/cetz:0.5.2"

= Vector Cross Product

Produces a new vector perpendicular to two others

$ c = a times b $

$ c_x = a_y b_z - a_z b_y $
$ c_y = a_z b_x - a_x b_z $
$ c_z = a_x b_y - a_y b_x $

== Visuals

#cetz.canvas({
  import cetz.draw: *

  let offset = 1

  let a_x = 2
  let a_y = 0

  let b_x = 1
  let b_y = 1

  let c_x = 0
  let c_y = 2

  line(
    (offset, offset),
    (a_x + offset, a_y + offset),
    mark: (end: "stealth"),
    name: "vector_a",
  )
  content("vector_a", text[$a$], anchor: "north")

  line(
    (offset, offset),
    (b_x + offset, b_y + offset),
    mark: (end: "stealth"),
    name: "vector_b",
  )
  content("vector_b", text[$b$], anchor: "north", angle: 45deg)

  line(
    (offset, offset),
    (c_x + offset, c_y + offset),
    mark: (end: "stealth"),
    name: "vector_c",
    stroke: red,
  )
  content("vector_c", text(red)[$c = a times b$], anchor: "east")

  let angle_indicator_size = 0.3
  line(
    (offset + angle_indicator_size, offset + angle_indicator_size),
    (offset, offset + angle_indicator_size),
    stroke: (paint: gray, dash: "dashed"),
  )
  line(
    (offset + angle_indicator_size, offset + angle_indicator_size),
    (offset + angle_indicator_size, offset),
    stroke: (paint: gray, dash: "dashed"),
  )

  line(
    (offset, offset + angle_indicator_size),
    (offset + angle_indicator_size, offset + angle_indicator_size * 2),
    stroke: (paint: gray, dash: "dashed"),
  )
  line(
    (offset + angle_indicator_size, offset + angle_indicator_size * 2),
    (offset + angle_indicator_size, offset + angle_indicator_size),
    stroke: (paint: gray, dash: "dashed"),
  )
})

Notice how the vector $c$ goes up. This depends on the coordinate system handedness and is the reason why winding order matters.

$b times a$ gives a new vector $c$ which goes down.

== Derivations

$ ||a times b|| = ||a|| ||b|| sin theta $
Where $theta$ is the angle between $a$ and $b$
