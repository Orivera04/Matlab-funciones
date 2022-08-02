function [optfunc,cfunc,constrArgs,fopts,optparams]=optimargs(L,B,DATA,Wc)   
% LOCALMOD/OPTIMARGS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 07:39:31 $



[LB,UB,A,c,nlcon,optparams]= constraints(L,DATA(:,1:end-1),DATA(:,end));

np= numParams(L);
Ns= size(DATA,3);

% work out some scale factors
s= abs(mean(B,2));
s(abs(s)<1e-6)=1;
s= 10.^round(log10(s));

if max(s)/min(s)>1e3
   % scale if range of parameters too great
   Scale= diag(1./s);
   InvScale= diag(s);
else
   Scale= eye(length(s));
   InvScale= Scale;
end

B0= Scale*B;

if ~isempty(UB)
   % don't scale infinite bounds
   UB= reshape(UB,size(B));
   isf= ~isfinite(UB);
   UBf= UB(isf);
   UB(isf)= 1;
   UB= Scale*UB;
   UB(isf)= UBf;
end
if ~isempty(LB)
   % don't scale infinite bounds
   LB= reshape(LB,size(B));
   isf= ~isfinite(LB);
   LBf= LB(isf);
   LB(isf)= 1;
   LB= Scale*LB;
   LB(isf)= LBf;
end

if ~isempty(A) | nlcon>0
   Hcell= cell(Ns,1);
   for i=1:Ns;
      Hcell{i}= ones(np);
   end
   H= spblkdiag(Hcell{:});
   
   [mn,g,tgt]= getcode(L);
   J= CalcJacob(L,tgt(:,2));
   if isempty(J)
      % no analytic jacobian
      Jcalc='off';
      lscale= 'off';
   else
      lscale= 'on';
      Jcalc='on';
   end
   fopts= optimset(optimset('fmincon'),...
      'display','off',...
      'HessPattern',H,...
      'gradobj',Jcalc);
   
   if ~isempty(A)
      % linear constraints
      sc= repmat(diag(InvScale),Ns,1);
      A= A*spdiags(sc,0,size(A,2),size(A,2));
      lscale='off';
   end
   if nlcon==0
      nlfunc= '';   
   else
      lscale='off';
      nlfunc= 'nlconstrlocal';
   end
   fopts= optimset(fopts,'largescale',lscale);
   
   optfunc = 'fmincon';
   cfunc   = 'gls_constrB';
   constrArgs= {A,c,[],[],LB,UB,nlfunc};
   
else
   Jcell= cell(Ns,1);
   ts= tsizes(DATA);
   for i=1:Ns;
      Jcell{i}= ones(ts(i),np);
   end
   JPattern= spblkdiag(Jcell{:});
   
   fopts= optimset(optimset('lsqnonlin'),...
      'display','off',...
      'largescale','on',...
      'jacobian','off',...
      'JacobPattern',JPattern,...
      'jacobian','off');
   
   optfunc= 'lsqnonlin';
   cfunc= 'gls_costB';
   
   constrArgs= {LB(:),UB(:)};
   
end

fopts= optimset(fopts,...
   'TolX',norm(B0)*1e-6);

r= gls_costB(B0,L,DATA,Wc,InvScale,1,optparams{:});
c0= sqrt(sum(r.^2));

optparams= {InvScale,c0,optparams{:}};
% model specify optimisation settings
fopts= foptions(L,fopts);
