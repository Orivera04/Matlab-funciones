function [n,u]=varname(m,newname,newunits);
% MODEL/VARNAME name and units for model
%
% [mname,munits]=varname(m);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:53:24 $

if nargin==1
   n= m.Yinfo.Name;
   u= m.Yinfo.Units;
else
   m.Yinfo.Name= newname;
   if nargin==3
      m.Yinfo.Units= newunits;
   end
   n= m;
end
   
