function d=Design(T,des)
% DESIGN
%
%   TP=DESIGN(TP,DES)
%   DES=DESIGN(TP)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:07:08 $

if nargin==1
	d= getdesign(T.DesignDev(end));
else
   T.DesignDev(end)= setdesign(T.DesignDev(end),des);
   pointer(T);
   d=T;
end
