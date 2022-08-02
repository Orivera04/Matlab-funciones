function display(obj)
%DISPLAY Display a cgvariable object
%
%  STR = DISPlAY(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:16:33 $

isLoose = strcmp(get(0,'FormatSpacing'),'loose');
if isLoose
   disp(' ')
end
disp(char(obj));
if isLoose
   disp(' ')
end