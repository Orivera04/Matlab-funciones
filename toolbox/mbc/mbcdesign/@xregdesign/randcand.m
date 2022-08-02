function [cand,ind]=randcand(des,p);
% DESIGN/RANDCAND   Generate p random candidate points
%   [C,IND]=RANDCAND(des,p) generates P random points from the
%   candidate list.  IND is a vector of indices which may be
%   used to regenerate the points.  The generated indices are
%   allowed/disallowed to be replicates of each other or points
%   in the current design according to the design object setting.
%
%   RANDCAND assumes the candidate list is ordered similarly to
%   that produced by CANDLIST; however RANDCAND does not generate
%   the full candidate list and hence can be much faster for
%   partial lists.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:34 $

% Created 28/10/99

if des.replicatedpoints
   % generate random numbers from full space
   ind=unidrnd(ncand(des),p,1);
else
   nps=ncandleft(des);
   if p<=nps
      % generate each random number from a smaller subset each time
      ind=unidrnd(nps:-1:nps-p+1);
      des_inds=double(des.designindex);
      if ~isempty(des.constraints)
         if des.constraintsflag<des.candstate
            % better re-eval constraints
            des=EvalConstraints(des);
         end
         % convert to indices in the constrained list
         % first remove any design indices ==0.  These slow down the findpoints routine
         % significantly and are never in the constraints InteriorPoints list
         des_inds=des_inds(des_inds>0);
         des_inds=findpoints(des.constraints,des_inds);
         des_inds=des_inds(~isnan(des_inds));
      end
      % convert inds to unique ones, from each other and from the current design
      ind=convunique(ind,des_inds);
   else
      % not enough candidate points to perform this operation!
      ind=[];
   end
end

if ~isempty(des.constraints)
   i2= interiorPoints(des.constraints);
   ind= double(i2(ind));
end
cand=partialset(des.candset,ind);
ind=ind(:);

return