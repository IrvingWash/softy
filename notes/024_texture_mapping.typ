= Texture Mapping

A texture has an arbitrary width and height in pixels.

Each vertex of a mesh has normalized coordinates into that texture, `u` and `v`.
`u` is horizontal, `v` is vertical.

So we need to step between vertices and retrieve texels from the texture.

In this project we have the origin of normalized texture coordinates at bottom left. So we have the following:
```
(0,1)           (1,1)


      (0.5,0.5)


(0,0)           (1,0)
```

Pyramide example:

#figure(
  image("./images/texture_mapping.png", height: 50%)
)
