function [des,psi]=adelete(des,initpsi,p,DO_DESIGNTYPE)
%DES_LINEARMOD/ADELETE   A-optimal deletion
%   [D,PSI]=ADELETE(D,INITPSI,P) deletes P lines from the design D
%   using a-optimality.  A new design object and the new
%   a-opimality criteria, PSI, are returned.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:33 $


if nargin<4
   DO_DESIGNTYPE=1;
end

fp = freepoints(des);
fs = factorsettings(des);

mmdl=model(des);
% set up matrices for each model
mdls = get(mmdl,'models');
wts = get(mmdl,'weights');
nmdls = get(mmdl,'nmodels');
X=cell(1,nmdls);
Ai=cell(1,nmdls);
for n=1:nmdls
   % Initial Ai must be for all points.  It is then iteratively
   % updated and hence is always correctly derived from all points.
   X{n}=CalcJacob(mdls{n},fs);
   
   [Q,R]= qr(X{n},0);
   ri= R\eye(size(R));
   
   Ai{n}= ri*ri';
   
   % X used for deletion point search is taken from the non-fixed
   % points in the design
   X{n}=X{n}(fp,:);
end

if DO_DESIGNTYPE
   % need to remember start point
   [TP,INFO]= DesignType(des);
end

psinew= initpsi;

for m=1:p
   psiupd = zeros(length(fp)-m+1,1);
   for n=1:nmdls
      % build up div as weighted sum
      % quick way
      B= X{n}*Ai{n};
      div=(1-sum(B.*X{n},2));
      
      Bi=wts(n).*sum( B.*B,2 );
      % check div isn't 0!!
      div=max(div,Bi*eps*2);
      % form output vector
      psiupd = psiupd + Bi./div;
   end
   
   [delpsi,i] = min(psiupd);   
   psinew = psinew+delpsi;
   
   if p>1
      for n=1:nmdls
         % Update Ai
         % Need to recalc the ith parts for each model
         Bi = X{n}(i,:)*Ai{n};
         divi = (1-sum(Bi.*X{n}(i,:),2));
         
         Ai{n}= mx_r1update(Ai{n},Bi/sqrt(divi),0);
         
         X{n}(i,:)=[];
      end
   end
   des=delete(des,'indexed',i,'changeable');
end
if DO_DESIGNTYPE
   % update design type
   des=DesignType(des,TP,INFO);         % reset object to initial setting
   des=UpdateDesignType(des,'v');       % update type setting
end

psi=psinew;
return