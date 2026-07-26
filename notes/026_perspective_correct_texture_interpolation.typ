= Perspective Correct Texture Interpolation

#figure(
  image("./images/perspective_incorrect_texture_mapping.png", height: 30%),
)

When texture is interpolated without regarding the perspective divide, the final mapping is distorted so the pixels are always parallel to the faces.
This is called "Affine Texture Mapping".

To fix the distortion, we need to find the depth at point $P$ inside the triangle.

#figure(
  image("./images/p_depth.png", height: 30%),
)

== Recipe to achieve perspecive corret interpolation

- We'll use the reciprocal of all attributes $(1/w)$.
- Then, interpolate over the triangle face using barycentric weights, $(1/w)$ factor.
- Divide all the attributes by $(1/w)$.
