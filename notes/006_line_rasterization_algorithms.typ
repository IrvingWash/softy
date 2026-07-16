= Line Rasterization Algorithms

== DDA (Digital Differential Analyzer)

Given we have $Delta x$ and $Delta y$, we compute $m$.

If $Delta x > Delta y$, we loop and grow from $x_0$ to $x_1$ by 1 per iteration and find $y_n$ using the $m$.
If $Delta y > Delta x$, than we find $x_n$ by moving $y_0$ to $y_1$.

```c
void draw_line(int x0, int y0, int x1, int y1) {
  int delta_x = x1 - x0;
  int delta_y = y1 - y0;

  int side_length = abs(delta_x) >= abs(delta_y)
    ? abs(delta_x)
    : abs(delta_y)

  float x_step = detla_x / (float)side_length;
  float y_step = delta_y / (float)side_step;

  float current_x = x0;
  float current_y = y0;

  for (int i = 0; i <= side_length; i++) {
    draw_pixel(round(current_x), round(current_y));

    current_x += x_step;
    current_y += y_step;
  }
}
```
