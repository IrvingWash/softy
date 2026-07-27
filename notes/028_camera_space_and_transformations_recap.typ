= Camera Space

To transform objects to the camera space we need to use the view matrix.

A camera usually has a position, a direction. FOV is usually put into the camera too.

== Quick Transformations Summary

1. When we start, the vertices of our mesh are in *model (local) space*. Usually the vertices are never changed relative to model space (maybe except animations and othre deformations).
2. Then we transform the vertices of our mesh to the *world space* by using the world transform (aka model transform?). So we place our mesh in a correct place in the world relative to the other objects (and the world's origin).
3. Then we convert the vertices of our mesh into *view (camera) space* so it's correctly situated relative to a viewpoint. This is done by multiplying by the view matrix.
4. Then we project the vertices into the *screen space*, so the vertices are correctly projected onto the canvas (screen).

== Camrea Models

There are several camera models. Some popular ones:
- Look-at Camera
- FPS Camera

#figure(
  image("./images/camera_models.png", height: 30%),
)
