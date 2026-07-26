= Z-buffer

Also called the depth-buffer. It stores the depth of each pixel in an array. It helps determining which framents are behind others, so we can skip processing them.

Often z-buffer values are represented as a gray-scale image. The nearest values are 1 (white), the furthest are 0 (black).
