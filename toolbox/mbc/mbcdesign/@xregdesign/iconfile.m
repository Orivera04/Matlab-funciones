function f=iconfile(des,ischosen)
%ICONFILE  Return a bitmap filename 
%
%  F=ICONFILE(DES,ISCHOSEN)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:06:56 $

if nargin<2
   ischosen=0;
end

if size(des,1)
   switch getstyle(des)
   case 0
      f='des_full';
   case 1
      f='des_optimal';
   case 2
      f='des_spacefill';
   case 3
      f='des_classical';
   case 4
      f='des_experimental';
   otherwise
      f='des_full';
   end
else
   f='des_empty';
end

if ischosen
   f=[f '_sel'];
elseif getlock(des)
   f=[f '_lock'];
end
f=[f '.bmp'];