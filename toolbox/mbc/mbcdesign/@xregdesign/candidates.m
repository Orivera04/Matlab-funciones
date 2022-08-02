function cand=candidates(des,varargin)
% DESIGN/CANDIDATES   Full candidate list
%   C=CANDIDATES(D) returns the full list of candidate
%   points.
%   C=CANDIDATES(D,OPTS) applies the OPTS to the candidate set:
%     OPTS = 'constrained'   : apply constraints list
%     OPTS = 'noreplacement' : take out any used design points
%
%   These options may be used in conjunction with each other.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:06:12 $

% Created 28/10/99


cand=fullset(des.candset);

if nargin>1
   des_ind=[];
   if any(strcmp(varargin,'noreplacement'))
      des_ind=des.designindex;
      des_ind=des_ind(des_ind>0);
   end
   if any(strcmp(varargin,'constrained')) & ~isempty(des.constraints)
      % check constraints state
      if des.constraintsflag<des.candstate
         % better re-eval constraints
         des=EvalConstraints(des);
      end
      i2=interiorPoints(des.constraints);
      if ~isempty(des_ind)
         % take out design indices
         i2=setxor(double(i2),des_ind);
      end
      cand=cand(i2,:);
   else
      if ~isempty(des_ind)
         cand(des_ind,:)=[];
      end
   end
end
return

