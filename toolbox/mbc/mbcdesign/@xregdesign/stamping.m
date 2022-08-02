function d=stamping(des,val)
% DESIGN/STAMPING  Turn date/time stamping on/off
%
%   ST=STAMPING(D) returns the current stamping state, 0 or 1.
%   D=STAMPING(D,ST) sets the stamping state to ST.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:49 $

% Created 12/11/99

if nargin==1
   d=des.stamping;
else
   des.stamping=~~val;
   if ~nargout
      nm=inputname(1);
      assignin('caller',nm,des);
   else
      d=des;
   end
end
