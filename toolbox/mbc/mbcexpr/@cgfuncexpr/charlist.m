function str = charlist(f)
%CHARLIST FuncExpr charlist method
%
%  STR = CHARLIST(OBJ) returns a recursive string describing this
%  expression.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:10:57 $

if isempty(f)
    str = '';
else
    inputs = getinputs(f);
    names = pveceval(inputs, 'charlist');
    str = [getname(f),'{', sprintf('%s, ', names{:})];
    str = str(1:end-1);
    str(end) = '}';
end