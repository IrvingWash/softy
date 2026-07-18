#import "@preview/cetz:0.5.2"

= Vector Addition

The addition itself if pretty easy. Just by-component addition.

$ c_x = a_x + b_x $
$ c_y = a_y + b_y $

#cetz.canvas({
  import cetz.draw: *

  let vector_a_x = 3
  let vector_a_y = 0

  let vector_b_x = 3
  let vector_b_y = 4

  let offset = 1

  line((0,0), (0,5), mark: (end: "stealth"), name: "x_axis")
  line((0,0), (5,0), mark: (end: "stealth"), name: "y_axis")

  line((offset, offset), (vector_a_x + offset, vector_a_y + offset), mark: (end: "stealth"), name: "vector_a")
  content("vector_a", text[$a$], anchor: "north")
  line((offset, offset), (vector_b_x + offset, vector_b_y + offset), mark: (end: "stealth"), name: "vector_b")
  content("vector_b", text[$b$], anchor: "south", angle: 50deg)
})

To visualize, we need to put one vector (without changing it, on the end of the other, so

#cetz.canvas({
  import cetz.draw: *

  let vector_a_x = 3
  let vector_a_y = 0

  let vector_b_x = 3
  let vector_b_y = 4

  let offset = 1

  line((0,0), (0,5), mark: (end: "stealth"), name: "x_axis")
  line((0,0), (5,0), mark: (end: "stealth"), name: "y_axis")

  line((offset, offset), (vector_a_x + offset, vector_a_y + offset), mark: (end: "stealth"), name: "vector_a")
  content("vector_a", text[$a$], anchor: "north")
  line((offset, offset), (vector_b_x + offset, vector_b_y + offset), mark: (end: "stealth"), name: "vector_b")
  content("vector_b", text[$b$], anchor: "south", angle: 50deg)

  line(
    (offset + vector_a_x, offset),
    (vector_b_x + offset + vector_a_x, vector_b_y + offset),
    mark: (end: "stealth"),
    stroke: (paint: gray, dash: "dashed"),
    name: "vector_b_projected",
  )
  content("vector_b_projected", text(gray)[$b$], anchor: "south", angle: 50deg)

  line((offset,offset), (6 + offset, 4 + offset), mark: (end: "stealth"), stroke: green, name: "vector_c")
  content("vector_c", text(green)[$c = a + b$], anchor: "north", angle: 35deg)
})

== Usage

Pretty intuitive: force addition, position addition, etc.
