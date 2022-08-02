function display(A);
% SWEEPSET/DISPLAY method for command line display of sweepset

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:06:09 $



isLoose = strcmp(get(0,'FormatSpacing'),'loose');
if isLoose
   disp(' ')
end
disp([inputname(1), ' = '])
disp(char(A));
if isLoose
   disp(' ')
end
  
      