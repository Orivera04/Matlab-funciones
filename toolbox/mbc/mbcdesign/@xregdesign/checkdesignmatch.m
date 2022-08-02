function [dout,ok]=checkdesignmatch(des,refdes)
% CHECKDESIGN  Check new design against current in testplan
%
%   [NEWD,OK]=CHECKDESIGN(D,REF_D) checks that the design D contains
%   all the points in REF_D - that is it can replace
%   the current one without needing a rematch.  NEWD is a sorted
%   version of D, with all matched points in the correct order and
%   fixed.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:06:17 $


fsold=factorsettings(refdes);
fixp=fixpoints(refdes);
% initial block of fixed points are assumed to be the matched ones
% which are necessary.
if isempty(fixp) | fixp(1)~=1
   % first point is not fixed! - assume any design is allowed
   ok=1;
   dout=des;
   return
end

df=find(diff(fixp)~=1);
if ~isempty(df)
   % trim off excess scattered fixpoints
   fixp=fixp(1:df);
end
fsold=fsold(fixp,:);

fsnew=factorsettings(des);

temp=zeros(size(fsnew));
len=size(temp,1);
lenold=size(fsold,1);
inds=zeros(1,lenold);
if len>=lenold
   for n=1:lenold
      temp=repmat(fsold(n,:),len,1);
      df=setdiff(find(all((abs(temp-fsnew)<(5*eps)),2)),inds(inds~=0));
      if ~isempty(df)
         inds(n)=df(1);
      else
         % one unfound > NOT ok
         break
      end
   end
else
   n=0;
end

if n<lenold
   ok=0;
   dout=[];
else
   ok=1;
   if nargout>1
      % sort new design
      allinds=1:len;
      allinds=setxor(allinds,inds);
      dout=reorder(des,[inds allinds]);
      dout=fixpoints(dout,inds);
   end   
end

return