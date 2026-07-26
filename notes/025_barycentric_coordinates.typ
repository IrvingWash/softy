= Barycentric Coordinates

#figure(
  image("./images/interpolating_texture_coordinates.png", height: 30%),
)

To find a texel for a point $P$ on a triangle face, we need to interpolate between uv-coordinates of each vertex.

One of the ways to interpolate is to use barycentric coordinates:
Each vertices UV values are our 3 weight values which are pulling $P$ towards themselves.

#figure(
  image("./images/pulling_weights.png", height: 15%),
)

Barycentric coordinates have to do with the triangle's area.

Each vertex pulls $P$, forming three triangles inside our original triangle.

The areas of these triangles are used to find the three pulling weights - $alpha$, $beta$ and $gamma$.

#figure(
  image("./images/alpha_beta_gamma.png", height: 20%),
)

$ P = (alpha, beta, gamma) $
$ alpha + beta + gamma = 1 $
$ arrow(P) = alpha arrow(A) + beta arrow(B) + gamma arrow(C) $

$alpha$ represents how much $P$ is being pulled to $A$. Other weights work the same.

$ alpha = "triangle_area"(P B C) / "triangle_area"(A B C) $
$ beta = "triangle_area"(A P C) / "triangle_area"(A B C) $
$ gamma = "triangle_area"(A B P) / "triangle_area"(A B C) $

To find the area we just use the vector cross product, because it's length is the area of the parallelogram made with the vectors.

$ alpha = ("parallelogram_area"(P B E C) / 2) / ("parallelogram_area"(A B D C) / 2) = "parallelogram_area"(P B E C) / "parallelogram_area"(A B D C) $

$ "parallelogram_area"(P B E C) = ||P C times P B|| $

$ alpha = (||P C times P B||) / (||A C times A B||) $

#figure(
  image("./images/alpha_parallelogram.png", height: 20%),
)

$ beta = (||A C times A P||) / (||A C times A B||) $

$ gamma = 1 - alpha - beta $
