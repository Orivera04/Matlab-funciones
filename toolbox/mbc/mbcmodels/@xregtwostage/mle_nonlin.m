function [TS,OK,xfinal]= mle_nonlin(TS,Xgc,Yrf,W0,ProgTable,CovAlg,TolFun)
%MLE_NONLIN Nested nonlinear mle estimator

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.4 $  $Date: 2004/04/04 03:30:48 $

% twostage covariance structure
[TS,OK]= pevinit(TS,Xgc,Yrf,W0,0,1);
xfinal=[];
if ~OK
    return
end

% scale the problem
[TS,Xs,Ys,W0s,S,SF]= mle_scale(TS,Xgc,Yrf,W0);

Ns= size(Yrf,1);
Nf= size(Yrf,2);

% get constraints
[loBnds,hiBnds,Ac,Bc,nlcon,optparams]= constraints(TS,Xgc,Yrf);

isNested=1;

if isempty(Ac) && nlcon==0;
    % optimisation options
    optfunc= 'lsqnonlin';
    foptslsq= optimset(optimset('lsqnonlin'),'display','off');
else
    optfunc= 'fmincon';
    foptslsq= optimset(optimset('fmincon'),'largescale','off','display','off');
    if nlcon
        nlcfunc= 'nlconstraints';
    else
        nlcfunc='';
    end

end

p0= nlparams(TS);
maxIter= 1 + ~isempty(p0);
for i= 1:maxIter;
    if isNested
        J= jacobian(TS,Xgc,1);
        % scaled
        Xs= S*J;
    else
        yhat= zeros(Nf,Ns);
        for i=1:Nf
            yhat(i,:)= eval(TS.Global{i},Xgc)';
        end
        %
        Xs= S*yhat(:);
    end
    if ~isempty(ProgTable)
        set(ProgTable{2},'string', sprintf('GLS Iteration %d',i))
    end
    % estimate covariance
    TS= feval(CovAlg,TS,Xs,Ys,W0s,ProgTable,isNested,TolFun);
    % calculate inv(Wc)'
    Wci= choltinv(TS.covmodel,W0s);


    % this does the nonlinear part of the problem
    % starting nonlinear values for model
    p0= nlparams(TS);
    if ~isempty(ProgTable)
        set(ProgTable{2},'string', sprintf('GLS Iteration %d',i))
        drawnow
    end
    OptArgs= {TS,Xgc,Yrf,Wci*S,isNested,optparams};
    if ~isempty(p0)
        if strcmp(optfunc,'lsqnonlin');
            [xf,f]= lsqnonlin('mle_nlcost',p0,loBnds,hiBnds,foptslsq,OptArgs{:});
        else
            % nonlinear constraints
            [xf,f]= fmincon('nonlin_sse',p0,Ac,Bc,[],[],loBnds,hiBnds,nlcfunc,foptslsq,OptArgs{:});
        end
    end
    % get updated model
    [r,TS]= mle_nlcost(xf,OptArgs{:});
end


TS.covmodel = unstruct_corr2cov(TS.covmodel,SF);
xfinal=  double(TS.covmodel);  % index upper triangular elements
