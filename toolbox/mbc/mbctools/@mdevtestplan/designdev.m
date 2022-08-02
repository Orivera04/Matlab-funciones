function out= DesignDev(T,newDD);
% TESTPLAN/DESIGNDEV

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:07:40 $

if nargin==1
	out= T.DesignDev;
else
	T.DesignDev=newDD;
	pointer(T);
	out= T;
end