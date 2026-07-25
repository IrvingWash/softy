= Row-major and Column-major Order

A row/column-major matrix is a matrix, simply put, which represents vectors either in each column or each row.

We use *column-major* matrices throughout the project:

$ arrow(v) = mat(x; y; z; delim: "[") $

As you can see, our vector is vertical or "columnial".

But a matrix can be *row-major*.

In that case a vector would look like this:

$ arrow(v) = mat(x y z; delim: "[") $

Because of the matrix multiplication rules, the orderness of a matrix determines whether a vector is on the left hand side or in the right hand side:
$ M * mat(x; y; z; delim: "[") $
$ mat(x y z; delim: "[") * M $

Matrices should be transposed to the same orderness to interact together.

Popular graphics APIs use different matrix types. OpenGL uses column-major matrices, DirectX uses row-major.
