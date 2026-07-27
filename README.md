# Softy

A software 3D renderer made while taking https://pikuma.com/courses/learn-3d-computer-graphics-programming
This is architecturally horrible - `main.jai` does many things that is should not. This is a learning/academic project, so architecture is not the biggest concern.

![Software rendered drone](./images/software_rendered_drone.png)

## Building

```bash
jai ./build.jai - --very-optimized +Autorun
```

## Lecture notes

The `notes` directory contains Typst lecture notes. They can be compiled to `.pdf` files:
```bash
typst compile name_of_note.typ
```

## Capabilities

- Rendering meshes loaded from Wavefront `.obj` files
- Flat-shading based on the sun-ray direction for colored meshes
- Textured rendering using barycentric coordinates
- Full matrix-based transformations (model, projection transformations)
- Z-buffering
