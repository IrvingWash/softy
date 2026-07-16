= Line Equation

#import "@preview/cetz:0.5.2"

#cetz.canvas({
  import cetz.draw: *

  line((0,0), (0,5), mark: (end: "stealth"), name: "y_axis")
  line((0,0), (5,0), mark: (end: "stealth"), name: "x_axis")

  line((1,3), (4,4), name: "the_line")
  content("the_line.start", text(blue)[$(x_0, y_0)$], anchor: "north")
  content("the_line.end", text(green)[$(x_1, y_1)$], anchor: "north-west")
})

$ y = m x + c $

$m$ - "the slope of the line" - the bigger $m$, the bigger the angle between the line and the $x$-axis.

$c$ - "$y$-intercept". Shifts the line along the $y$-axis. It's callect "$y$-intercept" because it marks the place where the line intercepts the $y$-axis.

== Derivations
#cetz.canvas({
  import cetz.draw: *

  line((0,0), (0,5), mark: (end: "stealth"), name: "y_axis")
  line((0,0), (5,0), mark: (end: "stealth"), name: "x_axis")

  line((1,3), (4,4), name: "the_line")
  content("the_line.start", text(blue)[$(x_0, y_0)$], anchor: "north")
  content("the_line.end", text(green)[$(x_1, y_1)$], anchor: "north-west")

  line((1,-0.1), (4,-0.1), name: "x_delta", stroke: gray, mark: (end: "stealth", start: "stealth"))
  content("x_delta", text(gray)[$Delta x$], anchor: "north")
  line((1,0), (1,3), stroke: (dash: "dashed", paint: gray))
  line((4,0), (4,4), stroke: (dash: "dashed", paint: gray))

  line((-0.1,3), (-0.1,4), name: "y_delta", stroke: gray, mark: (end: "stealth", start: "stealth"))
  content("y_delta", text(gray)[$Delta y$], anchor: "north-east")
  line((0,3), (1,3), stroke: (dash: "dashed", paint: gray));
  line((0,4), (4,4), stroke: (dash: "dashed", paint: gray));
})

== The angle
$ m = (Delta x) / (Delta y) $

$m$ is the $alpha$ of this right triangle, so:
$ tan alpha = (Delta x) / (Delta y) $
