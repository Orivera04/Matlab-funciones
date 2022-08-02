function out=constraints(des,c,touchflag)
% CONSTRAINTS  Return a copy of the constraints object
%
%  C=CONSTRAINTS(D) returns a copy of the constraints object in
%  the design D.
%
%  D=CONSTRAINTS(D,C) inserts a new constraints object into D.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:06:20 $



if nargin==1
   out= des.constraints;
else
   des.constraints= c;
   if nargin<3
      touchflag=1;
   end
   if touchflag
      des.candstate=des.candstate+1;
   end
   out=des;
end