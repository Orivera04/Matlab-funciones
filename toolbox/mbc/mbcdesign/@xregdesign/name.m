function d=name(des,nm)
% DESIGN/NAME   Get/set a name for a design object
%  
%   NM=NAME(D) returns a string identifying the design object
%   D=NAME(D,NM) sets the string to NM.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:12 $

% Created 12/11/99

if nargin==1;
   d=des.name;
else
   if ischar(nm)
      des.name=nm;
   end
   if ~nargout
      nm=inputname(1);
      assignin('caller',nm,des);
   else
      d=des;
   end
end
