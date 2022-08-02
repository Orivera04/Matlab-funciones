function [des, psi]=ddelete(des,initpsi,p,DO_DESIGNTYPE)
%DES_MULTIMOD/DDELETE   D-optimal deletion
%   [D,PSI]=DDELETE(D,INITPSI,P) deletes P lines from the design D
%   using d-optimality.  A new design object and the new
%   d-opimality criteria, PSI, are returned.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:36 $

% Created 25/5/99

if nargin<4
   DO_DESIGNTYPE=1;
end

mmdl=model(des);
fs= factorsettings(des);
mdls= get(mmdl,'models');
wts= get(mmdl,'weights');
fp=freepoints(des);
nmdls=length(wts);
for n=1:nmdls
   X=CalcJacob(mdls{n},fs);
   [Q,R]=qr(X,0);
   ri{n}=R\eye(size(R));
   ri{n}= chol(ri{n}*ri{n}');
   
   Xsmall{n}= X(fp,:)';
   Nt(n)= size(ri{n},1);
end

if DO_DESIGNTYPE
   % need to remember start point
   [TP,INFO]= DesignType(des);
end

Np=size(fs,1);
psinew=initpsi;
for n=1:p      
   % get new optimality criteria for if each line were removed
   % and test for maximum
   
   % alternative implementation - don't save whole d matrices for later on
   coef = ones(Np+1-n,1);
   for m=1:nmdls
      d= ri{m}*Xsmall{m};
      coef = coef.*((1-sum((d).^2)).^(wts(m)./Nt(m)))';
   end
   
   [delta,i]=max(coef);
   
   psinew=psinew+log(delta);
   
   if p>1
      for m=1:nmdls
         % apply changes to each stored matrix      
         % recalc the necessary bits
         di=ri{m}*Xsmall{m}(:,i);
         ri{m}=cholupdate(ri{m},(ri{m}'*di)/sqrt(1-sum(di.^2)));
         
         Xsmall{m}(:,i)=[];
      end
   end
   des=delete(des,'indexed',i,'changeable');
end

if DO_DESIGNTYPE
   % update design type
   des=DesignType(des,TP,INFO);         % reset object to initial setting
   des=UpdateDesignType(des,'d');       % update type setting
end

psi=psinew;
return