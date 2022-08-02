function [out,out2]= stats(m,RequiredStats,Xv,Yv);
% STATS
% 
% [out,out2]= stats(m,RequiredStats,Xv,Yv);
%
% Inputs
%   m              xreglinear object (or child)
%   RequiredStats  String specifying required stats
%                   'local'    [R^2 F p]
%                   'stepwise' [[AnovaTable [PRESS,PRESS_rsq,R2]'] , [beta stdB]]
%                   'diagnostics' {cookd leverage r y X studres yhat ci_hi ci_lo}
%   Xv             (Optional) Validation X data (only used if RequiredStats=='diagnostics')
%   Yv             (Optional) Validation Y data

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.3 $  $Date: 2004/02/09 07:50:13 $



OK=1;
if nargin>2
    IsOldData= false;
    if ~isempty(m.Store)
        % check to see if data already stored
        y= m.Store.y;
        IsOldData = isequal(size(y),size(Yv)) && norm(y-Yv) < sqrt(eps)*norm(y);
    end
    if ~IsOldData
        % new data passed in
        [m,OK]= InitModel(m,Xv,Yv);
    end
end
if ~isempty(m.Store) & OK
    % data in store
    X= m.Store.X;
    y= m.Store.y;
    H= m.Store.H;
    % delete zero leverage points
    % H(H==0)=[];
else
    error('INITSTORE or FITMODEL must be called before STATS');
end

% get rinv
[ri,mse,df]= var(m);


nobs = length(y);
if all(m.TermsOut) & ~m.Constant
    X = ones(size(X,1),1); 
    p    = 0;
    beta = 0;
    yhat = zeros(size(y));
else
    X(:,m.TermsOut)=[];
    p = size(X,2);
    beta = m.Beta(~m.TermsOut,1);
    yhat= X*beta;
end

r = y - yhat;

sse = sum(r.^2);  % Residual sum of squares.

if IncludeConst(m)
    ym= mean(y);
    sst = sum((y-ym).^2);     % Total sum of squares.
    ssr = sum((yhat-ym).^2);
    dfT= nobs-1;
else
    sst = sum(y.^2);     % Total sum of squares doesn't include mean
    ssr = sum(yhat.^2);
    dfT= nobs;
end
dfR= dfT-df;

if df <= 0
    mse = 0;
else
    mse = sse/df;
end

if dfR <= 0
    prob = 1;
    R2   = 0;
    F    = 0;
    ssr  = 0;
    msr  = 0;
elseif mse == 0
    msr= ssr/dfR;
    F = Inf;
    prob = 0;
    R2 = 1;
else
    msr= ssr/dfR;
    if sst>0
        R2   = ssr/sst;
    else
        R2  = 1;
    end
    F    = msr/mse;
    % Significance probability for regression
    prob=-1;
    % don't calculate F here as this gets called lots of times
    %   prob = 1 - fcdf(F,p-1,nobs-p);   
end

% for rols or ridge ssr and sse not orthoganal so F not valid
anova= [ssr dfT-df msr F prob
    sse df mse 0 0
    sst dfT 0 0 0];
    
% inv(R)*s	
% covariance matrix for coefficients
covb = ri*ri';

% leverage values
hneg= 1-H;
hneg(hneg==0)=eps;

%Adjusted R-squared statistic
if dfT==0
    adj_rsq= NaN;
else
    if sst>0
        adj_rsq = 1-(mse/(sst/dfT));
    elseif df>0
        adj_rsq = 1 - dfT/df;
    else
        adj_rsq = NaN;
    end
end



switch lower(RequiredStats)
    case 'local'
        if prob==-1
            prob = 1 - fcdf(F,dfR,dfT);   
        end
        out = [R2,F,prob];
    case 'ssedf'
        ytinv= get(m,'yinv');
        if ~isempty(ytinv)
            rn= ytinv(y)- ytinv(yhat);
            rn= rn(isfinite(rn));
            if ~isreal(rn)
                rn(imag(rn)~=0)=[];
            end
            ssen = sum(rn.^2);
        else
            ssen= sse;
        end
        out=[sse dfT-dfR ssen];
    case 'mse'
        out= mse;
    case 'anova'
        out = anova;
    case 'stepwise'
        %PRESS and PRESS R-squared
        PRESS = sum((r./(hneg)).^2);
        if sst==0
            PRESS_rsq=1;
        else
            PRESS_rsq = 1-(PRESS/sst);
        end
        out= [anova [PRESS,PRESS_rsq,R2]'];
        if nargout==2
            out2 = zeros(length(m.TermsOut),1);
            if ~all(m.TermsOut)
                out2(~m.TermsOut,:)= sqrt(diag(covb));
            end
        end
        return
    case 'summary'
        % natural residuals
        rn= yinv(m,y) - yinv(m,yhat);
        if any(~isfinite(rn)) | ~isreal(rn);
            mse= NaN;
        else
            if dfT-dfR == 0 
                mse = 0;
            else
                mse= sum(rn.^2)/(dfT-dfR);
            end      
        end
        if ~any(H==1)
            yhatp= yhat - H.*r./(hneg);
            rp= yinv(m,y) - yinv(m,yhatp);
            if any(~isfinite(rp)) | ~isreal(rp);
                msep= NaN;
            else
                msep= sum(rp.^2)/nobs;
            end
        else
            msep= NaN;
        end
        
        
        % [Nobs, nParams, Trans, PRESS RMSE, RMSE]
        out= [nobs p get(m,'boxcox') sqrt(msep) sqrt(mse)];
    case 'validate'
        % natural residuals
        rn= yinv(m,y) - yinv(m,yhat);
        % Externally Studentised Residuals
        if sse~=0
            SSI= (sse*(1-H)- r.^2)/(dfT-dfR-1);
            SSI = max(SSI,eps);
            % Externally Studentised Residuals
            studres=r./sqrt(SSI);
        else
            studres = zeros(size(r));
        end
        out= rn;
        out2= studres;   
    case 'diagnostics'
        leverage = H;
        if sse~=0 & dfT>dfR+1
            SSI= (sse*(1-H)- r.^2)/(dfT-dfR-1);
            SSI = max(SSI,eps);
            % Externally Studentised Residuals
            studres=r./sqrt(SSI);
        else
            studres = zeros(size(r));
            studres(:)= NaN;
        end
        if p>0
            cookd = studres.*studres .*(H./(hneg))./p;
        else
            cookd = zeros(size(r));
            cookd(:)= NaN;
        end
        
        %95% Confidence intervals on the response
        sb= sqrt(H*mse);
        cb= tinv(.975,nobs-p)*sb;
        
        ci_hi=yhat+cb;
        ci_lo=yhat-cb;
        
        out={cookd leverage r y X studres yhat ci_hi ci_lo};
        return
end