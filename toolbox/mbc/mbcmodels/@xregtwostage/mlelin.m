function [TS,xfinal]= mlelin(TS,Xs,Ys,W0s,ProgTable,isNested,TolFun)
% TWOSTAGE/MLELIN MLE estimates for linear using QN optimisation

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:58 $

% Uses Unconstrained optimisation
fopts= optimset(optimset('fminunc'),...
   'largescale','off',...
   'TolFun',TolFun,...
   'display','off');

if size(Xs,1) > 1000
   % display progress on command line for large scale problems
   fopts= optimset(fopts,'display','iter');
end
x0= double(TS.covmodel);
if ~isempty(ProgTable)
	set(ProgTable{2},'string','Quasi-Newton Covariance Estimation')
end

[cparams,f,exitflag]=fminunc('mlelincost',x0,fopts,TS.covmodel,Ys,Xs,W0s,isNested);

[f,Bmle]= mlelincost(cparams,TS.covmodel,Ys,Xs,W0s);

TS.covmodel= update(TS.covmodel,cparams);
% update global parameters
TS= mleparams(TS,Bmle);
xfinal= double(TS.covmodel);
