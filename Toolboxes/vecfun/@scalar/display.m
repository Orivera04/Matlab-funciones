function display(S)
%DISPLAY  Display a SCALAR object.

% Copyright 2001-04-14, B. Rasmus Anthin.

[x y z]=vars(S);
fprintf('\n     Scalar function:\n')
if isempty(S.xval), S.xval=x;end
if isempty(S.yval), S.yval=y;end
if isempty(S.zval), S.zval=z;end
beg(1:5)=' ';
fprintf([beg inputname(1) '(' S.xval ',' S.yval ',' S.zval ') = %s\n\n'],S.f)