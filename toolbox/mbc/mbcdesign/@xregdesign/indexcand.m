function [lines,lnind]=indexcand(des,ind,varargin)
% DESIGN/INDEXCAND   Returns specified lines from the candidate set
%   C=INDEXCAND(D,INDS) returns the lines specified by the 
%   generator numbers in INDS.  If constraints are present then INDS
%   will index the list of interior points from the constraints object.
%   [C,CIND]=INDEXCAND(D,INDS) returns the actual candidate set index
%   for each line in C.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:00 $

% Created 8/11/99


if nargin>2
   if any(strcmp(varargin,'noreplacement'))
      % make the indices unique
      des_inds=des.designindex;
      if  ~any(strcmp(varargin,'unconstrained'))
         if ~isempty(des.constraints)
            % check constraints state
            if des.constraintsflag<des.candstate
               % better re-eval constraints
               des=EvalConstraints(des);
            end
            % convert design indices to constraints list space
            % first remove any design indices ==0.  These slow down the findpoints routine
            % significantly and are never in the constraints InteriorPoints list
            des_inds=des_inds(des_inds>0);
            des_inds=findpoints(des.constraints,des_inds);
            des_inds=des_inds(~isnan(des_inds));
         end
      end
      % remove zeros: these create a false increment of 1 on ind
      des_inds=des_inds(des_inds>0);
      ind=convunique(ind,des_inds);  
   end
else
   varargin= '';
end

% default should be to constrain - hence this code cannot be inside
% the nargin part above
if  ~any(strcmp(varargin,'unconstrained'))
   if ~isempty(des.constraints)
      % use interior points
      % check constraints state
      if des.constraintsflag<des.candstate
         % better re-eval constraints
         des=EvalConstraints(des);
      end
      i2 = interiorPoints(des.constraints) ;
      ind= double(i2(ind));
   end
end

des=fixcandspace(des);
lines=partialset(des.candset,ind);
if nargout>1
   lnind=ind;   
end
