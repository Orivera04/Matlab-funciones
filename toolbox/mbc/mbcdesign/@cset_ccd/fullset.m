function out=fullset(obj)
% FULLSET  Return the full list of candidate points
%
%   LIST=FULLSET(OBJ) returns the full list of points in the
%   candidate set.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:00:10 $

% Created 15/11/2000

lims=limits(obj.candidateset)';
nf=size(lims,2);
cp=centerpoint(obj.candidateset);
% center points first
out(:,:)=repmat(cp ,npoints(obj), 1);   % note that the center points are needed for star points too

if obj.inscribe
   % inscribe:
   % 2^nf cube corners at [min max of range/alpha]
   % 2*nf star points at [min max]
   
   % ndgrid for cube corners
   cubelims=num2cell((repmat(cp,2,1)+(repmat(diff(lims,1,1),2,1)./([-2*obj.Alpha; 2*obj.Alpha])))',2);
   if nf>1
      % Generate N-D grid for evaluation
      [X{1:nf}]=ndgrid(cubelims{:});
   else
      X=cubelims;
   end
   alphlims=lims;
else
   % circumscribe:
   % 2^nf cube corners at [min max]
   % 2*nf star points at [min max of range*alpha]
   
   % alpha limits for star points
   alphlims=(repmat(cp,2,1)+(repmat(diff(lims,1,1),2,1).*([-0.5*obj.Alpha; 0.5*obj.Alpha])));
   
   % ndgrid for cube corners
   lims=num2cell(lims',2);
   if nf>1
      % Generate N-D grid for evaluation
      [X{1:nf}]=ndgrid(lims{:});
   else
      X=lims;
   end
end

st=obj.Nc+1;
ind=st:st+2^nf-1;
st=st+2^nf;
% do cube and star points in same loop
for n=1:nf
   out(ind,n)= X{n}(:);
   out(st+2*(n-1)+(0:1),n)=alphlims(:,n);
end
return