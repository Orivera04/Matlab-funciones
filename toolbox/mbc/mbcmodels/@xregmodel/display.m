function display(A);
% XREGMODEL/DISPLAY displays model in command window
%
% Calls child char functions

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:51:44 $



isLoose = strcmp(get(0,'FormatSpacing'),'loose');
if isLoose
   disp(' ')
end
disp([inputname(1), ' = '])
A=char(A,0);
b=blanks(size(A,1))';
disp([b b b A]);
if isLoose
   disp(' ')
end
  
      