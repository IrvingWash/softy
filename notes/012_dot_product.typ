#import "@preview/cetz:0.5.2"

= Dot Product

$ c = arrow(a) dot arrow(b) $
$ c = a_x b_x + a_y b_y $

Dot product is a scalar ratio which shows how much two vectors are aligned.

Dot product for two unit vectors is has range $[-1;1]$ where $-1$ is fully misaligned (-.-), and $1$ when fully aligned (the vectors are the same in that case?)

#cetz.canvas({
  import cetz.draw: *

  line(
    (0,0),
    (2,3),
    mark: (end: "stealth"),
    name: "vector_b"
  )
  content("vector_b.end", text[$arrow(b)$], anchor: "south-west")

  line(
    (0,0),
    (4,0),
    mark: (end: "stealth"),
    name: "vector_a"
  )
  content("vector_a.end", text[$arrow(a)$], anchor: "west")

  line(
    (0,0),
    (2,0),
    stroke: red,
    name: "alignment",
  )
  line(
    (2,3),
    (2,0),
    stroke: (dash: "dashed", paint: red),
    name: "alignment_projection"
  )
  content("alignment", text(red)[$a dot b$], anchor: "north")
})
