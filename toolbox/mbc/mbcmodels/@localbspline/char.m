function c= char(bs,TeX);
%CHAR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:01 $

if nargin<2
   TeX=1;
end

s= get(bs,'symbol');
if TeX
   s= detex(s);
end
c= char(bs.xreg3xspline,TeX);


