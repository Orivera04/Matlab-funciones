function ytrans=str_ytrans(model,TeX)
% model/str_ytrans
% ytrans=str_ytrans(model,TeX)
%   output a formatted string of the y transformation
%   TeX=1 adds TeX formatting

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/04/04 03:30:26 $
if isempty(TeX)
   TeX=0;
end
ytrans=[];
if ~isempty(model.ytrans);
   ytrans= sym(model.ytrans);
   if TeX
      ytrans = texlabel(ytrans);
   else
      ytrans = char(ytrans);
   end
end 
