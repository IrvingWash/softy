#import "@preview/cetz:0.5.2"

= Vector Normalization

Vector normalization is an operation which changes a vectors magnitude to $1$ (aka "unit vector") keeping it's direction.

#cetz.canvas({
  import cetz.draw: *

  line(
    (0,0),
    (0,4),
    mark: (end: "stealth"),
    stroke: green,
    name: "vector_a",
  )
  content(
    "vector_a",
    text(green)[$arrow(a)$],
    anchor: "west",
  )

  line(
    (0,0),
    (0,1),
    mark: (end: "stealth"),
    stroke: red,
    name: "vector_a_normalized",
  )
  content(
    "vector_a_normalized",
    text(red)[$hat(a)$],
    anchor: "west",
  )
})

= The formula

$ hat(a) = arrow(a) / (||arrow(a)||) $
