function  PEVout=evalpev(X,TS,translocal);
% TWOSTAGE/EVALPEV evaluate prediction error variance for a twostage model
%
% PEVout=evalpev(X,m);
%   This function is normally called via model/PEV
% A function to compute the Prediction error Variance of a multistage
% model. xg represents the values of the local and then global variables, 
% m is a Two Stage model object.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:59:38 $

if nargin<3
   translocal= 1;
end

% R = choltinv(m);
R= var(TS);
if isempty(R)
   error('PEV not initialised for twostage model')
end

L= TS.Local;

% number of global variables
n  = nfactors(TS.Global{1});
nl = nfactors(L);

Nf= size(L,1);

if iscell(X)
   GridEval= 1;
   % cell array used for pevgrid
   Xl= X{1};
   Xg= X{2};
   Xts= [zeros(size(Xg,1),nl) Xg];
   
   Ng= size(Xg,1);
   PEVout= cell(Ng,1);
   
else
   GridEval= 0;
   Xl= X(:,1:nl) ;					% Get local variable values.
   Xg= X(:,nl+1:end);			% Get global variable values.
   Xts= X;
   Ng= size(Xg,1);
   PEVout= zeros(Ng,1);
end

% global part of the jacobian
D= JacobGlobalVar(TS,Xg)*R;

% evaluate and get reconstruction parameters
[Y,Yg,Datum,Lparams] = eval(TS,X);

reEvalDG= ~allLinearRF(L);
if ~reEvalDG
   % inv(delg/delp) should be reevaluated here
   L= EvalDelG(L);
   dh=inv(delG(L));
end

for i= 1:Ng
   
   % Note that the last input here treats the local variable
   %  as relative to the datum 
   % this only works for a single output
   L= datum(L,Datum(i,:));
   L= update(L,Lparams(i,:)',[]);
   
	if reEvalDG
		% inv(delg/delp) should be reevaluated here
		L= EvalDelG(L);
		dh=inv(delG(L));
	end
	
   % local jacobian
   if GridEval;
      J = jacobian(L,Xl,0);
   else
      J = jacobian(L,Xl(i,:),0);
   end
   
   % local sweep jacobian* inv(delg/delp)
   M=  J*dh;
   
   % current sweep
   M= M*D((i-1)*Nf+1:Nf*i,:);
   
   % M should be mj x nloc_params
   
   if GridEval;
      PEVout{i}=sum(M.*M,2);
   else
      PEVout(i)=sum(M.*M,2);
   end
      
end	

if GridEval;
   PEVout= cat(1,PEVout{:});
end


if translocal
   yi= get(L,'yinv');
   if ~isempty(yi)
      % ordinary ytrans
      dy= yinvdiff(L,ytrans(L,Y));
      PEVout= dy.^2.*PEVout;
   elseif isTBS(L)
      % Y= cat(1,Y{:});
      set(L,'TBS',0)
      yhat = ytrans(L,Y);
      dy= yinvdiff(L,yhat);
      PEVout= dy.^2.*PEVout;
   end
end
   