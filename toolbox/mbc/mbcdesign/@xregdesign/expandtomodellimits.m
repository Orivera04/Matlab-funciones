function des=expandtomodellimits(des,from_tgt)
%EXPANDTOMODELLIMITS  Expand the design points to fill the current model space
%
%  DES=EXPANDTOMODELLIMITS(DES) will scale the design points' min/max so that 
%  they coincide with the current model's min/max.
%
%  DES=EXPANDTOMODELLIMITS(DES, LIMS)  provides a set of limits to use as the design 
%  points min/max.  This is a NF-by-2 matrix.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 07:06:29 $

if nargin<2
   % get from_tgt from design
   from_tgt=[min(des.design,[],1)' max(des.design,[],1)'];
end

new_lims=gettarget(model(des));
% Check we need to do anything
if size(new_lims,1)~=size(from_tgt,1)
   error('Number of factors has changed - cannot proceed');
   return
end

diffs=(abs(new_lims - from_tgt)>10*eps);
if any(diffs(:))
   % scale design
   X=des.design;
   for n=1:size(X,2)
      X(:,n)=new_lims(n,1) + (((X(:,n)-from_tgt(n,1)).*diff(new_lims(n,:))./diff(from_tgt(n,:)))); 
   end
   des.design=X;
   
   % change candidate set limits
   des.candset=limits(des.candset,new_lims);
   
   % change current design generator limits if there is one
   if des.style.base==2 | des.style.base==3
      des.style.baseinfo=limits(des.style.baseinfo,new_lims);
   end
   
   % constraints - delete them, they are no longer valid
   des=constraints(des,[]);
end