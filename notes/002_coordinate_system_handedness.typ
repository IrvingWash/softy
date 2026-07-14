#import "@preview/cetz:0.5.2"

= Coordinate system handedness

== Left handed
x -> goes right

y -> goes up

*z -> goes into the screen*

#cetz.canvas({
  import cetz.draw: *

  line((0,0), (2,1.5), mark: (end: "stealth"), stroke: blue, name: "z")
  content("z.end", text(blue)[$z$], anchor: "north")

  line((0,0), (0,3), mark: (end: "stealth"), stroke: green, name: "y")
  content("y.end", text(green)[$y$], anchor: "west")

  line((0,0), (3,0), mark: (end: "stealth"), stroke: red, name: "x")
  content("x.end", text(red)[$x$], color: red, anchor: "north-west")
})

DirectX is left-handed by default

== Right handed
x -> goes right

y -> goes up

*z -> goes outside the screen*

#cetz.canvas({
  import cetz.draw: *

  line((0,0), (-2,-1.5), mark: (end: "stealth"), stroke: blue, name: "z")
  content("z.end", text(blue)[$z$], anchor: "north")

  line((0,0), (0,3), mark: (end: "stealth"), stroke: green, name: "y")
  content("y.end", text(green)[$y$], anchor: "west")

  line((0,0), (3,0), mark: (end: "stealth"), stroke: red, name: "x")
  content("x.end", text(red)[$x$], color: red, anchor: "north-west")
})

OpenGL is right-handed by default
