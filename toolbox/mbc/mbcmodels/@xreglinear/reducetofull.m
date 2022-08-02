function m=reducetofull(m,x,ExtraDF)
%xreglinear/REDUCETOFULL   Reduce model to maximum fittable from x
%   M=REDUCETOFULL(M,X) reduces the number of terms in the model M 
%   until the regression matrix is full rank.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:50:02 $


ChangeOrder=0;
if ~m.Store.DispOrder
   ChangeOrder=1;
   m= InitStore2(m,m.Store.D);
end
if nargin<3
   ExtraDF=0;
end

f=fx(m);

t=Terms(m);
regm=f(:,t);
r= min(rank(regm),size(regm,1)-ExtraDF);
if r<size(regm,2)
   ss=sum(f.^2,1);
   % Now rescale ss so 0>ss>1
   ss=ss./max(ss);
   
   % Inherent importance weighting of each term in model.
   % current default...terms listed last ('higher order') are less importanat
   [tind, numord]=termorder(m);
   numord=[0 cumsum(numord) length(t)];
   for j=1:(length(numord)-1)
      term_importance(numord(j)+1:numord(j+1))=length(numord)-j;
   end
   
   % now scale term_importance to go from 0 to 1 as well
   term_importance=term_importance./max(term_importance);
   
   % weighting formula
   % use ranking=(ss+n*term_importance)*(is ss~=0?)
   % first plateau the ss for ss<a certain number
   ss(ss<.001)=0;
   n=1;
   rankings=(ss+n*term_importance).*(ss>0);
   
   % sort will proceed based firstly on above measure, then on the term_importance,
   % then on the position in the term list.  This makes sure that higher order
   % ss's of 0 go out before lower ones.
   rankings=[rankings' term_importance' (length(rankings):-1:1)'];
   
   [rankings,i]=sortrows(rankings,[1 2 3]);
   
   % re-sort current terms vector
   t=t(i);
   
   % take out nfactors-r terms
   ntakeout=size(regm,2)-r;
   % take out the first ntakeout terms that aren't already out
   % and that actually have an effect on the fullness of rank.
   count=0;
   j=1;
   while count<ntakeout
      if t(j)
         m=setstatus(m,tind(i(j)),2);
         m=IncludeAll(m);
         % check the rank has not gone down!
         f=x2fx(m,m.Store.D);
         rnew=rank(f(:,Terms(m)));
         if (rnew<r)
            % put term back in
            m=setstatus(m,tind(i(j)),3);
         else
            count=count+1;
         end
      end
      j=j+1;
   end
   
end

if ChangeOrder
   m= InitStore(m,m.Store.D);
end
