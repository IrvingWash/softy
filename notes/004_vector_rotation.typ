#import "@preview/cetz:0.5.2"

= Vector rotation

$ P = vec(x = 4, y = 2) $
$ alpha = 13degree $
$ beta = 37degree $
$ P' = vec(x', y') $

#cetz.canvas({
  import cetz.draw: *

  line((0,0), (0,5), mark: (end: "stealth"), stroke: green, name: "y_axis")
  content("y_axis.end", text(green)[y], anchor: "south-west")

  line((0,0), (5,0), mark: (end: "stealth"), stroke: red, name: "x_axis")
  content("x_axis.end", text(red)[x], anchor: "north-west")

  line((0,0), (4,2), stroke: (dash: "dashed", paint: yellow), name: "projection")
  content("projection", text(yellow)[$r$], anchor: "south-east")
  circle((4,2), radius: 0.05, fill: yellow, stroke: yellow, name: "point")
  content("point", text(yellow)[$P$], anchor: "north-west")

  circle((0,0), name: "alpha", radius: 0.01)
  content("alpha.end", text[$alpha$], anchor: "south-west", padding: (0.05, 0.5))

  circle((0,0), name: "beta", radius: 0.01)
  content("beta.end", text[$beta$], anchor: "south-west", padding: (0.3, 0.5))

  line((0,-0.3), (4,-0.3), mark: (end: "stealth", start: "stealth"), stroke: gray, name: "adjacent_size")
  content("adjacent_size", text(gray)[$x = 4$], anchor: "north")

  line((4.3,0), (4.3, 2), mark: (end: "stealth", start: "stealth"), stroke: gray, name: "opposite_size")
  content("opposite_size", text(gray)[$y = 2$], anchor: "west")

  circle((0,0), radius: 4.472, stroke: gray)

  line((0,0), (3,3.35), stroke: (dash: "dashed", paint: yellow), name: "projection_prime")
  content("projection_prime", text(yellow)[$r$], anchor: "south-east")
  circle((3,3.35), radius: 0.05, fill: yellow, stroke: yellow, name: "point_prime")
  content("point_prime", text(yellow)[$P'$], anchor: "north-west")

  line((3,0), (3,3.35), mark: (end: "stealth", start: "stealth"), stroke: gray, name: "adjacent_prime_size")
  content("adjacent_prime_size", text(gray)[$y'$], anchor: "west")

  line((0,3.35), (3, 3.35), mark: (end: "stealth", start: "stealth"), stroke: gray, name: "opposite_prime_size")
  content("opposite_prime_size", text(gray)[$x'$], anchor: "south")
})

== What we have
$ cos(alpha) = x/r $
$ x = cos(alpha)*r $

$ sin(alpha) = y/r $
$ y = sin(alpha)*r $

== What we get
$ cos(alpha + beta) = x'/r $
$ x' = cos(alpha + beta) * r $

$ sin(alpha + beta) = y'/r $
$ y' = sin(alpha + beta) * r $

== The formula
$ x' = r cos(alpha + beta) $
Angle addition formula for cosine:
$ x' = r(cos alpha cos beta - sin alpha sin beta) $ 
$ x' = r cos alpha cos beta - r sin alpha sin beta $

We derived above that $r cos alpha$ is $x$ and $r sin alpha$ is $y$, so...

=== X prime
$ x' = x cos beta - y sin beta $

=== Y prime

$ y' = sin(alpha + beta) * r $
Angle addition formula for sin:
$ y' = r(sin alpha cos beta + cos alpha sin beta) $
$ y' = r sin alpha cos beta + r cos alpha sin beta $
$ y' = y cos beta + x sin beta $

