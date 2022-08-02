function display(fexpr)
%DISPLAY Cgfuncexpr display method
%
%  DISPLAY(OBJ) displays the current state of OBJ at the command line.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:10:59 $

if strmatch(get(0 , 'formatspacing') , 'loose')
   str = ' ';
else
   str = '';
end

if isempty(fexpr)
    disp(str);
    disp('An Empty FuncExpr object');
    disp(str);
else
    inputs = getinputs(fexpr);
    num_inputs = nfactors(fexpr);
    if num_inputs>0
        len = length(inputs);
        disp(str)
        disp(sprintf('FuncExpr Object: %d required argument(s), %d argument(s) defined.', num_inputs, len));
        disp(str)   
    else
        disp('Empty FuncExpr Object');
    end
end