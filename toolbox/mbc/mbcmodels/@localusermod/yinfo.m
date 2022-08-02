function out= yinfo(m,yi);
% USERLOCAL/YINFO yinfo structure access
%
% fields 'Name','Units','Symbol'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:44:10 $

if nargin==1
   out= yinfo(m.xregmodel);
else
	m.xregmodel= yinfo(m.xregmodel,yi);
   m.userdefined= yinfo(m.userdefined,yi);
   out= m;
end      