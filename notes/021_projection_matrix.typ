#import "@preview/cetz:0.5.2"

= Projection Matrix

The projection matrix is responsible for:
- Aspect Ratio. Adjusting $x$ and $y$ values based on the canvas width and height.
- Field of View. Adjusting $x$ and $y$ values based on the FOV angle.
- Normalization. Adjusting $x$, $y$ and $z$ values to sit between $-1$ and $1$.
- Preserving Original $z$. Save the original unnormalized $z$ (depth value).
- Creating a perspective, orthographics, etc effect.

=== Aspect Ratio

Horizontal aspect ratio:
$ a = w / h $
Vertical aspect ratio:
$ a = h / w $
Where $w$ is the width of the canvas, and $h$ is the height.

We need this because a cube on a 16/9 screen would look stretchet horizontally. The aspect ratio helps to avoid that stretch.

=== FOV

Well, it's the opening of the camera.

The FOV is a parameter. The bigger it is, the more objects should we see. But our monitor (or canvas) has a fixed physical size, what to do?
It's easy, the bigger the FOV, the smaller the objects should be and vice-versa.

To scale, we need the ratio. Which (almost) happens to be $tan(theta/2)$, because of "sohcatoa", but I don't understand why it is the ratio (why opposite/adjacent is the useful ratio).
It "almost happens to be", because we want to make objects smaller as the angle grows, so we need the reciprocal:
$ f = 1/(theta/2) $

#cetz.canvas({
  import cetz.draw: *

  circle((0,-0.5), radius: 0.2, name: "eye")
  circle((0,-0.5), radius: 0.1, fill: black, name: "pupil")

  line(
    (0,0),
    (-3,5),
    name: "left_side",
    stroke: (dash: "dashed"),
  )
  content("left_side.start", text[$theta$], anchor: "south", padding: 0.3)

  line(
    (0,0),
    (3,5),
    name: "right_side",
    stroke: (dash: "dashed"),
  )

  line(
    (-3,5),
    (3,5),
    name: "top_side",
  )
  content(("top_side.start", 25%, "top_side.end"), text(gray)[opposite], anchor: "north")

  line(
    (0,0),
    (0,5),
    stroke: gray,
    name: "bisection",
  )
  content("bisection", text(gray)[adjacent], angle: 90deg, anchor: "south")
})

== So Far

Aspect Ratio. Because it's height/width, it only affects $x$.
$ a = h/w $

FOV factor. Affects $x$ and $y$.
$ f = 1/(tan(theta)) $

The transformation so far:

$
vec(
  x,y,z,
  delim: "[",
)

arrow

vec(
  a f x,
  f y,
  z,
)
$
