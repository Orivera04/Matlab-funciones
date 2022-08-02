function ytrans=ytransformat(model,TeX)
% MODEL/YTRANSFORMAT outputs a formatted string of the y transformation
%
% ytrans=ytransformat(model,TeX);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:53:34 $


% ytrans=ytransformat(model,TeX)
%   output a formatted string of the y transformation
%   TeX=1 adds TeX formatting
if isempty(TeX)
   TeX=0;
end
if ~isempty(model.ytrans);
   ytrans= sym(model.ytrans);
   ytrans= subs(ytrans,'x','y');
   if TeX
      ytrans = texlabel(ytrans);
   end
end 
