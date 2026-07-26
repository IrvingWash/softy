= Flat Shading

Flat shading is an algorithm which works on a per-face basis (it doesn't know anything about framents), so the whole face is affected.

It's quite simple - we check how much a face's normal is aligned with a light's direction. The bigger the alignment - the more illuminated the face is.

$ "alignment" = arrow("normal") dot arrow("light direction") $

So, the color factor is the $"alignment"$ which is a dot product between the normal of the face and the direction of the light.
