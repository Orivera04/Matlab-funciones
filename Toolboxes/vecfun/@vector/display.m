function display(V)
%DISPLAY  Display a VECTOR object.

% Copyright 2001-04-14, B. Rasmus Anthin.

[x y z xs ys zs]=vars(V);
fprintf('\n     Vector functions:\n')
if isempty(V.xval), V.xval=x;end
if isempty(V.yval), V.yval=y;end
if isempty(V.zval), V.zval=z;end
beg(1:5)=' ';vars=['(' V.xval ',' V.yval ',' V.zval ')'];equ=' = ';
fprintf([beg inputname(1) '.' x vars xs equ '%s\n'],V.fx)
fprintf([beg inputname(1) '.' y vars ys equ '%s\n'],V.fy)
fprintf([beg inputname(1) '.' z vars zs equ '%s\n\n'],V.fz)