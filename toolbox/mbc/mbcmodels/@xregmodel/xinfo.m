function out= xinfo(m,xi);
% MODEL/XINFO xinfo structure access
%
% fields 'Names','Units','Symbols'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:53:26 $

if nargin==1
   out= m.Xinfo;
else
   if isstruct(xi) & all(ismember({'Names','Units','Symbols'},fieldnames(xi)))
	  xi.Names= xi.Names(:);
	  xi.Symbols= xi.Symbols(:);
	  xi.Units= xi.Units(:);
      m.Xinfo= xi;
      out= m;
   else
      error('Structure input with fields ''Names'',''Units'',''Symbols'' is required')
   end
end      