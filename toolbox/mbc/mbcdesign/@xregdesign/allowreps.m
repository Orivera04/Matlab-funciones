function out=allowreps(des,st)
% DESIGN/ALLOWREPS   Set and get the replicated points flag
%   D=ALLOWREPS(D,FLG) sets the design flag which indicates
%   whether replicated points should be allowed in the current
%   design.  FLG is either 0 for no replicates (default) or >0
%   to allow replicates.
%   FLG=ALLOWREPS(D) returns the current value of the flag.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:06:08 $

% Created 4/11/99

if nargin==1
   out=des.replicatedpoints;   
else
   des.replicatedpoints=(st>0);
   if ~nargout
      nm=inputname(1);
      assignin('caller',nm,des);
   else
      out=des;
   end   
end
return
