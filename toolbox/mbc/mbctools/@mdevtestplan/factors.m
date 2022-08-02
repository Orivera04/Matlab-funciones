function f=factors(T,newnames)
% MDEVTESTPLAN?FACTORS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:07:44 $

if nargin==1
	f= factorNames(T.DesignDev,':');
else
	T.DesignDev= factorNames(T.DesignDev,':',newnames);
   pointer(T);
   f=T;
end