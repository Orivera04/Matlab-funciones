function obj=loadobj(obj)
% LOADOBJ   Load older object versions
%
%   OBJ=LOADOBJ(STRUCT)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:12 $

% Created 29/1/2001


if isa(obj,'cset_ccd')
   return
else
   if obj.version<2
      % add parameter for inscribed/circumscribed
      obj.inscribe=0;
   end
   
   obj=cset_ccd(obj);
end