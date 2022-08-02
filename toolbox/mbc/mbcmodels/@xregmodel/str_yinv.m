function ytrans=str_yinv(model,TeX)
% model/str_yinv
% ytrans=str_yinv(model,TeX)
%   output a formatted string of the inverse y transformation
%   TeX=1 adds TeX formatting

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:53:14 $
if isempty(TeX)
   TeX=0;
end
ytrans=[];
if ~isempty(model.yinv);
   ytrans= sym(model.yinv);
	if TeX
		yvar= detex(model.Yinfo.Name);
	else
		yvar= model.Yinfo.Name;
	end
	ytrans= subs(ytrans,'y','MbCMARkerfOryvarIABLe');  % substitute in an easily recognisable string
   if TeX
      ytrans = texlabel(ytrans);
   else
      ytrans = char(ytrans);
   end
   % place actual data name string
   ytrans = strrep(ytrans,'MbCMARkerfOryvarIABLe',yvar);
end 
