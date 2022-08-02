function display(A)
%DISPLAY Display the model in command window

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:57:45 $

isLoose = strcmp(get(0,'FormatSpacing'),'loose');
if isLoose
   disp(' ')
end
disp([inputname(1), ' = '])
A=char(A.mvModel,0);
b=blanks(size(A,1))';
disp([b b b A]);
if isLoose
   disp(' ')
end
  
      