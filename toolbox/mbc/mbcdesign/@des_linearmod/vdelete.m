function [smod,psi]=vdelete(smod,initpsi,p,DO_DESIGNTYPE)
%DES_LINEARMOD/VDELETE   V-optimal deletion
%   [D,PSI]=VDELETE(D,INITPSI,P) deletes P lines from the design D
%   using v-optimality.  A new design object and the new
%   v-opimality criteria, PSI, are returned.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:50 $

% Created 8/11/99

if nargin<4
   DO_DESIGNTYPE=1;
end
if DO_DESIGNTYPE
   [TP,INFO]=DesignType(smod);
end

[K,n]=sumxtx(smod);
K=K./n;
% Initial Ai must be for all points.  It is then iteratively
% updated and hence is always correctly derived from all points.
X=CalcJacob(model(smod),factorsettings(smod));

[Q,R]= qr(X,0);
ri= R\eye(size(R));

Ai=ri*ri';

% X used for deletion point search is taken from the non-fixed
% points in the design
X=X(freepoints(smod),:);

psinew= initpsi;

for m=1:p
   % quick way
   B= X*Ai;
   div=(1-sum(B.*X,2));
   
   Bi=sum( B.*(B*K),2 );
   div=max(div,Bi*eps*2);
   
   [delpsi,i]=min( Bi./div);
   psinew=psinew+delpsi;
   if p>1
      % Update Ai
      Ai= mx_r1update(Ai,B(i,:)/sqrt(div(i)),0);
      X(i,:)=[];
   end
   smod=delete(smod,'indexed',i,'changeable');
end

if DO_DESIGNTYPE
   % update design type
   smod=DesignType(smod,TP,INFO);         % reset object to initial setting
   smod=UpdateDesignType(smod,'v');       % update type setting
end

psi=psinew;

return