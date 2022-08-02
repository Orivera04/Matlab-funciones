function [s,list,SummStatsType,Description]= summary(m,Criteria,X,y)
%XREGMODEL/SUMMARY
%
% [s,list,SummStats]= summary(m,Criteria,s2);
% [MINorMAX,list,SummStats]= summary(m) returns a list of criteria and whether
% to use as summary 
%
% Criteria list = {'RMSE','-2logL','AIC','AICc','BIC','R^2','R^2 adj'}


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.6.1 $  $Date: 2004/02/09 07:53:17 $

list= {'RMSE','R^2','R^2 adj','-2logL','AIC','AICc','BIC','DW'};
SummStatsType= [-1 1 1 2 2 2 2 1];
% don't use RMSE as summary stats (calculated in stats method
if nargout>3
    Description= {'Root Mean Square Error'          'sqrt(SSE/(N-p))'
        'R^2'                                       '1 - SSE/SST'
        'Adjusted R^2'                              '1 - SSE/SST*(N-1)/(N-p)'
        '-2 * log likelihood'                       '-2*N*log(SSE/N)'
        'Akaike Information Criteria'               '-2logL + 2*(p+1)'
        'Small Sample Akaike Information Criteria'  '-2logL + 2(p+1)*N/(N-p)'
        'Bayesian Information Criteria'             '-2logL + 2*log(N)*(p+1)'
        'Durbin-Watson Statistic'                   'sum((r_t-r_{t+1})^2)/sum((r_t^2) '};
end


if nargin<2 
    % true indicates minimise and false maximise
    s= true(size(list));
    s(2:3)= false;
    return
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


[ri,mse,df] = var(m);% degrees of freedom
sse= sum( (y-eval(m,X)).^2 );
            
% assume df= nObs-p
nObs= size(y,1);

s2mle= sse/nObs;
if nargin<3
    s2 = mse;
end

logL= sse/s2mle + nObs*log(s2mle);


s= zeros(1,length(sel));
for i=1:length(sel)
    switch sel(i)
        case 1
            % RMSE
            s(i) = sqrt(mse);
        case 2
            sst = sum((y-mean(y)).^2);
            % R^2
            if sst>0
                s(i)= 1-sse/sst;
            else
                s(i)= 1;
            end
        case 3
            sst = sum((y-mean(y)).^2);
            dfT= nObs-1;
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
        case 4
            % log likelihood  actually -2logL
            if s2mle~=0
                s(i)= nObs + nObs*log(s2mle);
            else
                s(i)= NaN;
            end
        case 5
            % Akaike Information Criteria
            K= nObs-df+1; % note variance is included as a parameter
            if s2mle~=0
                s(i) = nObs*log(s2mle) + 2*K;
            else
                s(i)= NaN;
            end
        case 6
            % AICc Akaike Information Criteria for small samples
            K= nObs-df+1;
            if s2mle~=0
                s(i) = nObs*log(s2mle) + 2*K + 2*K*(K+1)/(nObs-K-1);
            else
                s(i)= NaN;
            end
        case 7
            % Bayesian Information Criteria
            K= nObs-df+1;
            if s2mle~=0
                s(i) = nObs*log(s2mle) + log(nObs)*K;
            else
                s(i)= NaN;
            end
        case 8
            % Durban-Watson
            yhat= eval(m,X);
            r= y - yhat;
            s(i)= sum( (r(1:end-1)- r(2:end)).^2 ) /sum(r.^2);
    end
end
