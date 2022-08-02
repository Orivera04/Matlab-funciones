function f=DesignGrid(T,x)
% DEVTESTPLAN/DESIGNGRID

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:07:09 $

if nargin==1
	des= Design(T);
   if ~isempty(des)
      f= factorsettings(des);
   else
      f=[];
   end
else
	des= Design(T);
	des= factorsetings(des,x);
	T= Design(T,des);
   f=T;
end