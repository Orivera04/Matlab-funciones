function n=ncand(des,opt)
% DESIGN/NCAND  Return the total number of candidate points
%   N=NCAND(D) returns the total number of candidate points
%   currently available to choose from.
%   N=NCAND(D,'unconstrained') returns the total number of
%   candidates in the unconstrained candidate set.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:07:13 $

% Created 8/11/99

if nargin==1
   opt='';
end

if ~(strcmp(lower(opt),'unconstrained')) & ~isempty(des.constraints)
   if des.constraintsflag<des.candstate
      % Doh! Re-eval them!!
      des=EvalConstraints(des);
      % attempt to place back in caller workspace
      nm = inputname(1);
      if ~isempty(nm)
         assignin('caller',nm,des);
      end
   end
   n = length(interiorPoints(des.constraints));
else
   % fix any inconsistencies
   des=fixcandspace(des);
   
   n=npoints(des.candset);
end
