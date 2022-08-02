function des=delete(des,method,numlines,opt)
%DELETE  Delete lines from current design
%
%  D=DELETE(D,METHOD,P) deletes p lines drom the design object D, using
%  method METHOD.  Valid methods are 'random', 'indexed'.  For indexed, P
%  is a vector of indices into the design.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:06:23 $

switch lower(method)
case 'random'
   t=des.npoints;
   % Create the random index list
   ind=unidrnd(t:-1:t-numlines+1);
   % convert ind to be used for points that aren't replaced
   % This could be vectorized but I'm looking to save memory too
   % and its easy to mex this for speed if necessary
   ind=convunique(ind);
   des.design(ind,:)=[];
   des.designindex(ind)=[];
   des.designpointflags(ind)=[];
   des.npoints=des.npoints-numlines;
   
case 'indexed'
   % 3rd argument is a list of indices to be deleted
   
   % if opt is 'changeable', only index the non-fixed points and as
   % far as possible try to keep the fixed points at the same positions
   if (nargin>3) & strcmp(opt,'changeable')
      baseinds=1:des.npoints;
      inds=find(~pGetFlags(des, 'FIXED'));
      numlines(numlines>length(inds))=[];
      newinds=inds;
      newinds(numlines)=[];
      inds=inds(1:length(newinds));
      baseinds(inds)=newinds;
      des.designindex=des.designindex(baseinds);
      des.designpointflags=des.designpointflags(baseinds);
      des.design=des.design(baseinds,:);
      ndels=length(numlines);
      des.designindex=des.designindex(1:(end-ndels));
      des.designpointflags=des.designpointflags(1:(end-ndels));
      des.design=des.design(1:(end-ndels),:);
   else
      numlines(numlines>des.npoints)=[];
      des.design(numlines,:)=[];
      des.designindex(numlines)=[];
      des.designpointflags(numlines)=[]; 
   end
   des.npoints=des.npoints-length(numlines);
end

des=DesignType(des,0,[]);
des=timestamp(des,'stamp');
des.designstate=des.designstate+1;
