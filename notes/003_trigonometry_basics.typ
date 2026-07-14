#import "@preview/cetz:0.5.2"

= Trigonometry basics

#cetz.canvas({
  import cetz.draw: *

  line((0,0), (5,0), stroke: blue, name: "adjacent")
  content("adjacent", text(blue)[adjacent], anchor: "north")

  line((5,0), (5,3), stroke: green, name: "opposite")
  content("opposite", text(green)[opposite], anchor: "west")

  line((0,0), (5,3), stroke: purple, name: "hypotenuse")
  content("hypotenuse", text(purple)[hypotenuse], anchor: "east")

  circle((0,0), radius: 0.01, name: "alpha")
  content("alpha", text[$alpha$], anchor: "south-west", padding: (0.05, 0.4))
})

== Sin, Cos, Tan

$ sin(alpha) = "opposite"/"hypotenuse" $

$ cos(alpha) = "adjacent"/"hypotenuse" $

$ tan(alpha) = "opposite"/"adjacent" $

A mnemonic:
$ s = o/h $
$ c = a/h $
$ t = o/a $
