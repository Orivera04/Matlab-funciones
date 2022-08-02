function [smod, psi]=ddelete(smod,initpsi,p,DO_DESIGNTYPE)
%DES_LINEARMOD/DDELETE   D-optimal deletion
%   [D,PSI]=DDELETE(D,INITPSI,P) deletes P lines from the design D
%   using d-optimality.  A new design object and the new
%   d-opimality criteria, PSI, are returned.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:17 $

% Created 4/11/99

if nargin<4
   DO_DESIGNTYPE=1;
end
if DO_DESIGNTYPE
   [TP,INFO]=DesignType(smod);
end

X=CalcJacob(model(smod),factorsettings(smod));

[Q,R]=qr(X,0);
ri=R\eye(size(R));
ri= chol(ri*ri');
 
X= X(freepoints(smod),:)';

Np= size(ri,1);
psinew=initpsi;
for n=1:p      
   % get new optimality criteria for if each line were removed
   % and test for maximum
   d= ri*X;
   [coef,i]=min(sum((d).^2));
   
   psinew=psinew+log(1-coef)./Np;
   
   if p>1
      ri=cholupdate(ri,(ri'*d(:,i))/sqrt(1-coef));
      
      X(:,i)=[];
   end
   smod=delete(smod,'indexed',i,'changeable');
end

if DO_DESIGNTYPE
   % update design type
   smod=DesignType(smod,TP,INFO);         % reset object to initial setting
   smod=UpdateDesignType(smod,'d');       % update type setting
end

psi=psinew;
return





