function [s,list,SummStatsType,Description] = summary(m,Criteria,X,y,s2,s2mle)
%SUMMARY Calculate summary statistics
%
%  [s,list,SummStats] = SUMMARY(m,Criteria,s2);
%  [MINorMAX,list,SummStatsType] = SUMMARY(m) returns a list of criteria
%  and whether to use as summary:
%    -1 special calculation done differently in summary stats
%     1 use as calculated 
%     2 only compare if data and transforms the same for all models
%     0 don't use for comparison in summary table (only in prune)
%
%  Criteria list = {'PRESS RMSE','RMSE','GCV','Weighted  PRESS',...
%                  '-2logL','AIC','AICc','BIC','R^2','R^2 adj','Cp'}

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.6.2 $  $Date: 2004/02/09 07:50:16 $

list= {'PRESS RMSE','RMSE','GCV','Weighted PRESS','-2logL','AIC','AICc','BIC','R^2','R^2 adj','PRESS R^2','DW','Cp'};
SummStatsType= [-1 -1 1 1 2 2 2 2 1 1 1 1 0];
if nargout>3
    Description= {'Predicted Standard Error'        'sqrt(PRESS/N)'
        'Root Mean Square Error'                    'sqrt(SSE/(N-p))'
        'Generalized Cross-validation Variance'     'N*SSE/(N-p)^2'
        'Weighted Predicted Standard Error'         'sqrt(PRESS/(N-p-1))'
        '-2 * log likelihood'                       '-2*N*log(SSE/N)'
        'Akaike Information Criteria'               '-2logL + 2*(p+1)'
        'Small Sample Akaike Information Criteria'  '-2logL + 2(p+1)*N/(N-p)'
        'Bayesian Information Criteria'             '-2logL + 2*log(N)*(p+1)'
        'R^2'                                       '1 - SSE/SST'
        'Adjusted R^2'                              '1 - SSE/SST*(N-1)/(N-p)'
        'PRESS R^2'                                 '1 - PRESS/SST'
        'Durbin-Watson Statistic'                   'sum((e_i-e_{i+1})^2)/sum((e_i^2) '
        'Mallow''s Statistic'                       'SSE/(SSEmax/(N-pmax)) - N + 2*p'};
end


if nargin<2 
    % true indicates minimise and false maximise
    s= true(size(list));
    s(9:11)= false;
    return
end
if nargin<4 || isempty(X);
    X= m.Store.X;
    y= m.Store.y;
end


if ischar(Criteria)
    switch lower(Criteria)
        case 'all'
            sel= 1:length(list);
        case 'data'
            sel= find(abs(SummStatsType)~=1);
        case 'summary'
            sel= find(abs(SummStatsType)~=0);
        case 'multi'
            sel= find(SummStatsType<=0);
        otherwise
            sel= find(ismember(list,Criteria));
    end
elseif iscell(Criteria)
    sel= find(ismember(list,Criteria));
elseif islogical(Criteria)
    sel= find(Criteria);
else
    sel= Criteria;
end

nObs=size(y,1); 

[ri,mse,df] = var(m);% degrees of freedom
Stats= stats(m,'stepwise');    
PRESS= Stats(1,end);
dfT= Stats(end,2);
sst= Stats(end,1);
sse= Stats(2,1);

s2mle= sse/nObs;
if nargin<3
    s2 = mse;
end

s= zeros(1,length(sel));
for i=1:length(sel)
    switch sel(i)
        case 1
            % PRESS RMSE
            s(i) = sqrt(PRESS/nObs);
        case 2
            % RMSE
            s(i) = sqrt(mse);
        case 3
            % GCV
            s(i) = calcGCV(m);
        case 4
            % Weighted PRESS
            s(i) = sqrt(PRESS/(df-1));
        case 5
            % log likelihood  actually -2logL
            if s2mle~=0
                s(i)= nObs + nObs*log(s2mle);
            end
        case 6
            % Akaike Information Criteria
            K= nObs-df+1; % note variance is included as a parameter
            if s2mle~=0
                s(i) = nObs*log(s2mle) + 2*K;
            else
                s(i)= NaN;
            end
        case 7
            % AICc Akaike Information Criteria for small samples
            K= nObs-df+1;
            if s2mle~=0 && nObs>K+1
                s(i) = nObs*log(s2mle) + 2*K*nObs/(nObs-K-1);
            else
                s(i)= NaN;
            end
        case 8
            % Bayesian Information Criteria
            K= nObs-df+1;
            if s2mle~=0
                s(i) = nObs*log(s2mle) + log(nObs)*K;
            else
                s(i)= NaN;
            end
        case 9
            % R^2
            if sst>0
                s(i)= 1-sse/sst;
            else
                s(i)= 1;
            end
        case 10
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
            s(i)= adj_rsq;
        case 11
            if sst>0
                s(i)= 1-PRESS/sst;
            else
                s(i)= 1;
            end
        case 12
            % Durban-Watson
            yhat= eval(m,X);
            r= y - yhat;
            s(i)= sum( (r(1:end-1)- r(2:end)).^2 ) /sum(r.^2);
        case 13
            % Mallow' Statistic
            s(i)= sse/s2 - df + numParams(m);

    end
end
