function out= xinfo(m,xi);
% USERLOCAL/XINFO xinfo structure access
%
% fields 'Names','Units','Symbols'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:44:09 $

if nargin==1
   out= xinfo(m.xregmodel);
else
   m.xregmodel= xinfo(m.xregmodel,xi);
   m.userdefined= xinfo(m.userdefined,xi);
   out= m;
end      