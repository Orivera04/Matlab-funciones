function display(obj)
%DISPLAY

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:08:43 $

% Sweepset/display uses inputname(1) in it's display so try and propagate that name

isLoose = strcmp(get(0,'FormatSpacing'),'loose');
if isLoose
   disp(' ')
end

disp([inputname(1), ' = '])
disp(char(obj));

if isLoose
   disp(' ')
end
