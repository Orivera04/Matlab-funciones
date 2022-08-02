function out= yinfo(m,xi);
% MODEL/YINFO yinfo structure access
%
% fields 'Name','Units','Symbol'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:53:29 $

if nargin==1
   out= m.Yinfo;
else
   if isstruct(xi) & all(ismember({'Name','Units','Symbol'},fieldnames(xi)))
      m.Yinfo= xi;
      out= m;
   else
      error('Structure input with fields ''Name'',''Units'',''Symbol'' is required')
   end
end      