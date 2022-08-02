function [mlist,name]= buildmodels(m,nobs);
%BUILDMODELS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.6.4.2 $  $Date: 2004/02/09 07:45:18 $



[mink,maxk,om,ok]= ModelBuildGUI(m,'create',nobs);
if ok
   nf= nfactors(m);   
   mlist= cell(1,maxk-mink+1);
   mInd = 1;
   for i=mink:maxk
      set(m,'order',i*ones(1,nf));
      set(m,'maxinteract',i);
      j=i-1;
      while size(m,1)>nobs & j>0
         set(m,'maxinteract',j);
         j=j-1;
      end
      
      if ~isempty(om)
         m = setFitOpt(m,om);
      end
      mlist{mInd}= m;
      mInd = mInd+1;
   end
   name= 'Polynomial';
else
   name= '';
   mlist={};
end