function [B,yhat,res,J]= gls_fitB(bs,B,DATA,Wc)
% LOCALBSPLINE/GLS_FITB least-squares estimation of localbspline
%
% [B,res,J,yhat]= gls_fitB(ps,B,DATA,Wc)
%   bs    localbspline object
%   B     initial parameter matrix (cols= sweeps)
%   DATA  sweepset of data to fit [X,Y]
%   Wc    optional weights Wc'*Wc= inv(covmatrix)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 07:38:12 $



Ns= size(DATA,3);
if nargin < 4 | isempty(Wc)
   Wc=cell(1,Ns);
end

% setup Jacobian pattern
J= cell(1,Ns);
Hcell= cell(1,Ns);
tst= tsizes(DATA);
nk= get(bs.xreg3xspline,'numknots');
for i=1:Ns;
   J{i}= ones(tst(i),nk);
   Hcell{i}= ones(nk);
end
% sparse block diagonal
JPattern= spblkdiag(J{:});
HPattern= spblkdiag(Hcell{:});



[lb,ub,A,c,nlc,alpha]= constraints(bs,DATA(:,1:end-1),DATA(:,end),B);

bs.fitparams.ColMap= [];
bs.fitparams.JPattern= JPattern;

knots= B(1:nk,:);


fopts= optimset(optimset('lsqnonlin'),...
   'display','off',...
   'diagnostics','off',...
   'TolFun',1e-6,...
   'Tolx',1e-3,...
   'LargeScale','on');

% Jupp constraints (non-log)
Tgt=gettarget(bs);
% bounds small +ve number
LBjupp= ones(nk,1)*max(abs(Tgt))*sqrt(eps);
UBjupp= [];


rs = bs.fitparams.randstart+1;
ss= zeros(rs,1);
kf=knots;

k0= knots;
for j=1:Ns
    % sweep range
    JTgt= [lb(1,j) ub(1,j)];
    jdata= DATA(:,:,j);
    
    ss = Inf;
    % start with previous values
    k0i= knots(:,j);
    for i=1:rs
        kj0= jupp(bs.xreg3xspline,k0i,JTgt);
        % initial cost
        rj= lsqresiduals(kj0,bs,jdata,Wc(j),1,0,JTgt);
        ssi= sum(rj.^2);
        if ssi<ss
            x0=  k0i;
            ss= ssi;
            ind= i;
        end
        % initial conditions for next iteration
        k0i= rand(nk,1).*(ub(:,j)-lb(:,j))+lb(:,j); 
        k0i= sort(k0i);
    end
    k0(:,j)= x0;
    
    % penalty 
    h=diff([JTgt(1),x0(:)',JTgt(2)])/(JTgt(2)-JTgt(1));
    div= (sum(log((nk+1)*h)));
    alpha(j)= -0.1/min(-0.01,div);
    
    % turn knots into jupp parameters
    kj0= jupp(bs.xreg3xspline,x0,JTgt);
    % initial cost
    rj= lsqresiduals(kj0,bs,jdata,Wc(j),1,alpha(j),JTgt);
    c0= sum(rj.^2);
    kj0= kj0(:);
    [kf(:,j),cj]=lsqnonlin('lsqresiduals',kj0,LBjupp,UBjupp,fopts,...
        bs,jdata,Wc(j),c0,alpha(j),JTgt);
end

[res,B,yhat]= lsqresiduals(kf,bs,DATA,Wc,1,zeros(size(alpha)),[lb(1,:)' ub(1,:)']);

J= cell(Ns,1);
for i=1:Ns
	bs= update(bs,B(:,i));
	Xs= DATA{i};
	J{i}= CalcJacob(bs,Xs(:,1:end-1));
end

drawnow



