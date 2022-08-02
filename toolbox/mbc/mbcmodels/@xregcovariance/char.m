function ch= char(c,TeX,MSE);
%CHAR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:46:03 $


ch= '';
if nargin ==3
   % should also display covariance model
   ch= ['s^2 = ',sprintf('%.4g',MSE)];
end

if ~isempty(c.wfunc)
   if ~isempty(ch)
      ch= [ch,'*'];
   end  
   wp= sprintf('%.4g,',c.wparam);
   wp= wp(1:end-1);
   ch= [ch c.wfunc,'(y,',wp,')'];
end
if ~isempty(c.cfunc)
   if ~isempty(ch)
      ch=[ch,'*'];
   end
   wp= sprintf('%.4g,',c.cparam);
   wp= wp(1:end-1);
   if nargin==2 & TeX
      ch= [ch,c.cfunc,'(\epsilon_i,',wp,')'];
   else
      ch= [ch,c.cfunc,'(e,',wp,')'];
   end
end

