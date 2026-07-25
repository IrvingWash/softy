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
$ f = 1/tan(theta/2) $

It looks like FOV factor normalizes $x$ and $y$ values but I'm not sure.

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

=== Normalizing Z-Values

We pick a z-near and a z-far value to cut objects that are too close and too far.

#cetz.canvas({
  import cetz.draw: *

  circle((0,-0.5), radius: 0.2, name: "eye")
  circle((0,-0.5), radius: 0.1, fill: black, name: "pupil")

  line(
    (0,0),
    (-3,5),
    name: "left_side",
  )

  line(
    (0,0),
    (3,5),
    name: "right_side",
  )

  line(
    (-3,5),
    (3,5),
    stroke: (dash: "dashed", paint: yellow),
    name: "top_side",
  )
  content(
    "top_side",
    "z far",
    anchor: "south",
  )

  line(
    (-3,1.5),
    (3,1.5),
    stroke: (dash: "dashed", paint: yellow),
    name: "z_near",
  )
  content(
    "z_near",
    "z near",
    anchor: "south",
  )

  line(
    (3,0),
    (3,1.5),
    stroke: (dash: "dashed", paint: green),
    name: "z_near_offset",
  )
  content(
    "z_near_offset",
    text(green)[znear offset/translation],
    anchor: "west",
    padding: 0.1,
  )
})

Objects in 3D world have a variety of $z$ values - $300$, $140$, $977$, etc.
We need to normalize all these values between $0$ and $1$.

$ f(z) = (lambda_s z + lambda_t)/z $
$lambda_s$ - scale factor
$lambda_t$ - translation factor

$ (lambda_s "znear" + lambda t) / "znear" = 0 arrow lambda_s "znear" + lambda_t = 0 $
$ (lambda_s "zfar" + lambda t) / "zfar" = 1 arrow lambda_s "zfar" - lambda_s "znear" = "zfar" $

$ lambda_s = "zfar" / ("zfar" - "znear") $

$ lambda_t = -("zfar" / ("zfar" - "znear")) "znear" = -lambda_s "znear" $

== So Far

Aspect Ratio. Because it's height/width, it only affects $x$.
$ a = h/w $

FOV factor. Affects $x$ and $y$.
$ f = 1/(tan(theta / 2)) $

Z-normalization.
$ lambda = ? $

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
  lambda z,
)
$

$
mat(
  (h/w) (1/(tan(theta/2))), 0, 0, 0;
  0, (1/(tan(theta/2))), 0, 0;
  0, 0, "zfar" / ("zfar" - "znear"), -("zfar" / ("zfar" - "znear")) "znear";
  0, 0, 1, 0;
  delim: "[",
)

*

vec(
  x,y,z,1,
  delim: "[",
)

=

vec(
  x_p,y_p,z_p,w_p = z,
  delim: "[",
)

->

vec(
  x_p/z,
  y_p/z,
  z_p/z,
  delim: "[",
) = "NDC"
$

The $1$ in $m_(4 3)$ instead of the $m_(4 4)$, as we are used to, because this allows to store the original (non-normalized) $z$ value in the $w$ component. Because we need the original value for texture mapping and maybe for the depth buffer.

=== FAQ

Q: Why we don't performe the perspective device right in the matrix?
A: Because between projection and the divide we also may perform clipping.
