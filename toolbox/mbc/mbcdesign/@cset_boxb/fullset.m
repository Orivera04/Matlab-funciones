function out=fullset(obj)
% FULLSET  Return the full list of candidate points
%
%   LIST=FULLSET(OBJ) returns the full list of points in the
%   candidate set.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.2.2 $  $Date: 2004/02/09 06:59:53 $

lims=limits(obj.candidateset)';
nf=size(lims,2);
% cp=centerpoint(obj.candidateset);
% % center points first
% out=repmat(cp ,npoints(obj), 1);   % note that the center points are needed for star points too

% % generate basic 2-d 2-level full-factorial as basic component
% cmp=[lims(1,1) lims(1,1);
%    lims(1,1) lims(2,1);
%    lims(2,1) lims(1,1);
%    lims(2,1) lims(2,1)];

% if nf>1
%    Ncmp_perms = sum(1:(nf-1));
%    
%    % index matrix
%    indx=(tril(ones(nf-1))~=0);
%    indx(indx)=1:Ncmp_perms;
%    indx=+indx;   % remove logical flag
%    indx=(indx-1)*4 + 1;
%    indx(:,:,4)=indx(:,:,1)+3;
%    indx(:,:,3)=indx(:,:,1)+2;
%    indx(:,:,2)=indx(:,:,1)+1;
%    indx=permute(indx,[3 1 2]);
%    
%    % first factor
%    out(obj.Nc+ indx(:,:,1),1) = repmat(cmp(:,1),nf-1,1);
%    % loop over inner factors 
%    for n=2:nf-1
%       cmp=[lims(1,n) lims(1,n);
%          lims(1,n) lims(2,n);
%          lims(2,n) lims(1,n);
%          lims(2,n) lims(2,n)];
%       out(obj.Nc+indx(:,n:end,n),n) = repmat(cmp(:,1),nf-n,1);
%       out(obj.Nc+indx(:,n-1,1:(n-1)),n) = repmat(cmp(:,2),n-1,1);
%    end
%    % last factor
%    cmp=[lims(1,end) lims(1,end);
%       lims(1,end) lims(2,end);
%       lims(2,end) lims(1,end);
%       lims(2,end) lims(2,end)];
%    out(obj.Nc+indx(:,end,:),end) = repmat(cmp(:,2),nf-1,1);
% elseif nf==1
%    out(obj.Nc+1:end)=[lims(1,1);lims(2,1)];
% end



if nf>=3 & nf<=5
   % 2^2 design
   cmp=[-1 -1;
      -1 1;
      1 -1;
      1 1];
elseif nf>=6 & nf<=7
   % 2^3 design
   cmp=[-1 -1 -1;
      -1 -1 1;
      -1 1 -1;
      -1 1 1;
      1 -1 -1;
      1 -1 1;
      1 1 -1;
      1 1 1];
else
   % unsupported number of factors
   out=[]; 
   return
end

out=zeros(npoints(obj),nf);
blkdes=i_basicblk(nf);
L_cmp=size(cmp,1);
insert_pos=1;
tmp=zeros(L_cmp,nf);
for k=1:size(blkdes,1)
   tmp(:,:)=0;
   tmp(repmat(blkdes(k,:),L_cmp,1))=cmp;
   out(insert_pos:insert_pos+L_cmp-1,:)=tmp;
   insert_pos = insert_pos + L_cmp;
end


% re-scale output
for k=1:nf
   out(:,k) = lims(1,k) + (out(:,k)+1).*(lims(2,k)-lims(1,k))./2;
end




function blkdes=i_basicblk(nf)
switch nf
case 3
   blkdes=[1 1 0;
      1 0 1;
      0 1 1];
case 4
   blkdes=[1 1 0 0;
      0 0 1 1;
      1 0 0 1;
      0 1 1 0;
      1 0 1 0;
      0 1 0 1];
case 5
   blkdes=[1 1 0 0 0;
      0 0 1 1 0;
      0 1 0 0 1;
      1 0 1 0 0;
      0 0 0 1 1;
      0 1 1 0 0
      1 0 0 1 0;
      0 0 1 0 1;
      1 0 0 0 1;
      0 1 0 1 0];
case 6
   blkdes=[1 1 0 1 0 0;
      0 1 1 0 1 0;
      0 0 1 1 0 1;
      1 0 0 1 1 0;
      0 1 0 0 1 1;
      1 0 1 0 0 1];
case 7
   blkdes=[0 0 0 1 1 1 0;
      1 0 0 0 0 1 1;
      0 1 0 0 1 0 1;
      1 1 0 1 0 0 0;
      0 0 1 1 0 0 1;
      1 0 1 0 1 0 0;
      0 1 1 0 0 1 0];
end
blkdes= blkdes~=0;