function [B,res,J,yhat]= gls_fitB(D,B,DATA,varargin)
%% LOCALMOD/GLS_FITB fit coefficients (B) in IGLS
%%
%% [B,res,J,yhat]= gls_fitB(D,B,DATA,Wc) 
%%
%% fopts= fitoptions(D);
%%
%% DATA is X,Y data for each sweep; sweeps in (pseudo) 3rd dim
%% X has 2 columns for DYNAMIC objects, [t, u(t)]
%% Y is a single col of output data
%% B has rows = params, one col per sweeps (this determines its size)
%% Last arg is a cell array of weight mtxs, one for each sweep.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:58:54 $

% get limits
if nargin<4
   varargin={[]};
end

np = length(double(D));
if np==2
   minb= [eps 0]';
   maxb= [Inf Inf]';   
else
   minb= [repmat([eps 0],[1,(np-1)/2]) 0]';
   maxb= [repmat([Inf Inf],[1,(np-1)/2]) Inf]';
end
%% s (col vector) is abs mean b across all cols (sweeps) 
%s= abs(mean(B,2));
%if max(s)/min(s) > 1e2 %% large difference in scale between different B params
%   Scale= diag(1./s); %% diagonal mtx with 1/mean(b) vals (in turn) down diagonal
%   InvScale= diag(s);
%else %% use mtx that does nothing
Scale= eye(length(np));
InvScale= Scale;
%end
%B= Scale*B; %% mtx with col = b-vals for sweep rescaled with mean over all sweeps
%if ~isempty(maxb)
%   isf= isfinite(maxb(:));
%   maxb= repmat(maxb(:),1,size(DATA,3));
%   maxb(isf)= Scale(isf,isf)*maxb(isf);
%end
%if ~isempty(minb)
%   isf= isfinite(minb(:));
%   minb= repmat(minb(:),1,size(DATA,3));
%   minb(isf)= Scale(isf,isf)*minb(isf);
%end
%%-------------------- IGNORE THIS (above)------------------------------

Ns= size(DATA,3); %% num of sweeps

[ri,Jp]= gls_costB(B,D,DATA,varargin{:},InvScale);
c0= sqrt(sum(ri.^2));
options= optimset('display','off',...
   'Tolfun',1e-6,...
   'TolX',norm(B)*1e-6,...
   'jacobian','off',...
   'DiffMaxChange ',2,...
   'DiffMinChange ',0.1,...
   'LargeScale','off');
%% norm(B) = max singular val of B

%% do each sweep individually
for i = 1:Ns
   [B(:,i),resnorm,r,exitflag,output] = ...
      lsqnonlin('gls_costB',B(:,i),minb(:),maxb(:),...
      options,D,DATA(:,:,i),varargin{:},InvScale,c0);
   
   if exitflag>0
      DisplayFit(D,'LSQ solution converged');
   elseif exitflag==0
      DisplayFit(D,['LSQ exceeded maximum number',...
            ' of iterations -> rerun ']);
   else
      DisplayFit(D,'LSQ solution did not converge');
   end
end

%%% insurance? in case B has got misshapen
%% or if Inf values were junked??
%B= reshape(B,size(D,1),size(DATA,3));
%B= InvScale*B;
[res,J,yhat]= gls_costB(B,D,DATA,varargin{:});