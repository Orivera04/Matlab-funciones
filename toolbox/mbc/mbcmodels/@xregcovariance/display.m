function display(c)
%DISPLAY

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:46:11 $

isLoose = strcmp(get(0,'FormatSpacing'),'loose');
if isLoose
   disp(' ')
end
if ~isempty(inputname(1))
   disp([inputname(1), ' = '])
else
   disp([ans, ' = '])
end
fprintf('\n');
disp(char(c))
fprintf('\n');
if isLoose
   disp(' ')
end
  