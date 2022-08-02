function c=char(m,hg)
%CHAR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:58:16 $

if nargin < 2
   hg=1;
end

m3= copymodel(m,m.mv3xspline); 
c=char(m3,hg);
