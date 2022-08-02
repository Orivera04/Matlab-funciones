function s = char(u,TeX)
% USERLOCAL/CHAR 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:41:56 $

if nargin<2
   TeX=1;
end

s= char(u.userdefined,TeX);
