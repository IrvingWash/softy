#import "@preview/cetz:0.5.2"

= Vector Subtraction

The subtraction itself if pretty easy. Just by-component subtraction.

$ c_x = a_x - b_x $
$ c_y = a_y - b_y $

#cetz.canvas({
  import cetz.draw: *

  let vector_a_x = 2
  let vector_a_y = 0

  let vector_b_x = 1
  let vector_b_y = 2

  let offset_x = 2
  let offset_y = 3

  line((0,0), (0,5), mark: (end: "stealth"), name: "x_axis")
  line((0,0), (5,0), mark: (end: "stealth"), name: "y_axis")

  line((offset_x, offset_y), (vector_a_x + offset_x, vector_a_y + offset_y), mark: (end: "stealth"), name: "vector_a")
  content("vector_a", text[$a$], anchor: "north")
  line((offset_x, offset_y), (vector_b_x + offset_x, vector_b_y + offset_y), mark: (end: "stealth"), name: "vector_b")
  content("vector_b", text[$b$], anchor: "south", angle: 65deg)
})

== Visualization

1. Invert the rhs vector ($c = a + (-b)$)

#cetz.canvas({
  import cetz.draw: *

  let vector_a_x = 2
  let vector_a_y = 0

  let vector_b_x = 1
  let vector_b_y = 2

  let offset_x = 2
  let offset_y = 3

  line((0,0), (0,5), mark: (end: "stealth"), name: "x_axis")
  line((0,0), (5,0), mark: (end: "stealth"), name: "y_axis")

  line((offset_x, offset_y), (vector_a_x + offset_x, vector_a_y + offset_y), mark: (end: "stealth"), name: "vector_a")
  content("vector_a", text[$a$], anchor: "north")
  line((offset_x, offset_y), (vector_b_x + offset_x, vector_b_y + offset_y), mark: (end: "stealth"), name: "vector_b")
  content("vector_b", text[$b$], anchor: "south", angle: 65deg)

  line(
    (offset_x, offset_y),
    (-vector_b_x + offset_x, -vector_b_y + offset_y),
    mark: (end: "stealth"),
    name: "vector_b_inverted",
    stroke: (dash: "dashed", paint: gray),
  )
  content("vector_b_inverted", text(gray)[$-b$], anchor: "south", angle: 65deg)
})

2. Move the inverted vector to the tip of the lhs vector

#cetz.canvas({
  import cetz.draw: *

  let vector_a_x = 2
  let vector_a_y = 0

  let vector_b_x = 1
  let vector_b_y = 2

  let offset_x = 2
  let offset_y = 3

  line((0,0), (0,5), mark: (end: "stealth"), name: "x_axis")
  line((0,0), (5,0), mark: (end: "stealth"), name: "y_axis")

  line((offset_x, offset_y), (vector_a_x + offset_x, vector_a_y + offset_y), mark: (end: "stealth"), name: "vector_a")
  content("vector_a", text[$a$], anchor: "north")
  line((offset_x, offset_y), (vector_b_x + offset_x, vector_b_y + offset_y), mark: (end: "stealth"), name: "vector_b")
  content("vector_b", text[$b$], anchor: "south", angle: 65deg)

  line(
    (offset_x + vector_a_x, offset_y + vector_a_y),
    (-vector_b_x + offset_x + vector_a_x, -vector_b_y + offset_y + vector_a_y),
    mark: (end: "stealth"),
    name: "vector_b_inverted",
    stroke: (dash: "dashed", paint: gray),
  )
  content("vector_b_inverted", text(gray)[$-b$], anchor: "south", angle: 65deg)
})

3. And get the $c$ vector

#cetz.canvas({
  import cetz.draw: *

  let vector_a_x = 2
  let vector_a_y = 0

  let vector_b_x = 1
  let vector_b_y = 2

  let offset_x = 2
  let offset_y = 3

  line((0,0), (0,5), mark: (end: "stealth"), name: "x_axis")
  line((0,0), (5,0), mark: (end: "stealth"), name: "y_axis")

  line((offset_x, offset_y), (vector_a_x + offset_x, vector_a_y + offset_y), mark: (end: "stealth"), name: "vector_a")
  content("vector_a", text[$a$], anchor: "north")
  line((offset_x, offset_y), (vector_b_x + offset_x, vector_b_y + offset_y), mark: (end: "stealth"), name: "vector_b")
  content("vector_b", text[$b$], anchor: "south", angle: 65deg)

  line(
    (offset_x + vector_a_x, offset_y + vector_a_y),
    (-vector_b_x + offset_x + vector_a_x, -vector_b_y + offset_y + vector_a_y),
    mark: (end: "stealth"),
    name: "vector_b_inverted",
    stroke: (dash: "dashed", paint: gray),
  )
  content("vector_b_inverted", text(gray)[$-b$], anchor: "south", angle: 65deg)

  line(
    (offset_x, offset_y),
    (3, 1),
    mark: (end: "stealth"),
    name: "vector_c",
    stroke: green,
  )
  content("vector_c", text(green)[$c = a - b$], anchor: "north", angle: -65deg)
})

== Usage
Gives the difference. Pretty intuitive as well. Fox example gives a vector which describes the position difference between positions $a$ and $b$.
