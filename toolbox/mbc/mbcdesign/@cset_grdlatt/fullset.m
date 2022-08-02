function out=fullset(obj);
% FULLSET  Return the full list of candidate points
%
%   LIST=FULLSET(OBJ) returns the full list of points in the
%   candidate set.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:32 $

% Created 1/11/2000

l=length(obj.lattdims);
g=length(obj.griddims);
if l==0
   out=fullset(obj.grid);
elseif g==0
   out=fullset(obj.lattice);
else
   n=npoints(obj);
   N=get(obj.lattice,'N');
   
   % mixture
   out=zeros(N,(n./N),nfactors(obj)); 
   
   % do lattice
   out(:,1,obj.lattdims)=fullset(obj.lattice);
   % replicate down through the layers
   out(:,2:end,obj.lattdims)=repmat(out(:,1,obj.lattdims),[1 (size(out,2)-1) 1]);
   
   % do grid
   out(1,:,obj.griddims)=reshape(fullset(obj.grid),[1 size(out,2) g]);
   % replicate down the rows
   out(2:end,:,obj.griddims)=repmat(out(1,:,obj.griddims),[N-1 1 1]);
   
   out=reshape(out,[n nfactors(obj)]);
end
return