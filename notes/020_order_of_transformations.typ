= Order of Transformations

1. Scale
2. Rotate
3. Translate

Read right to left:
$
mat(T, delim: "[") * mat(R, delim: "[") * mat(S, delim: "[") * arrow(v)
$

Order matters because different orders give differen results.

First rotating and then translating will rotate an object around it's own center and then translate.

First translating and then rotating will first move the object and only then rotate around the point where the object was before translation.
