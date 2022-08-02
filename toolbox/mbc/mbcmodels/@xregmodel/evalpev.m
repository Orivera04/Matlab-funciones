function p= evalpev(x,m,varargin);
% MODEL/EVALPEV default evalpev 
% 
% this is to prevent utilities falling over.
% it should be overloaded to do something meaningful

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:51:48 $

p= zeros(size(x,1),1);

