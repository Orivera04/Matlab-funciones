function [s,list,SummStatsType,Description]= summary(m,Criteria,X,y)
%XREGARX/SUMMARY
%
% [s,list,SummStats]= summary(m,Criteria,s2);
% [MINorMAX,list,SummStats]= summary(m) returns a list of criteria and whether
% to use as summary 
%
% Criteria list = {'RMSE','GCV','-2logL','AIC','AICc','BIC','R^2','R^2 adj'}


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:45:42 $

list= {'RMSE','DW'};
SummStatsType= [-1 2];
% don't use RMSE as summary stats (calculated in stats method
if nargout>3
    Description= {'Root Mean Square Error'          'sqrt(SSE/(N-p))'
        'Durbin-Watson Statistic'                   'sum((r_t-r_{t+1})^2)/sum((r_t^2) '};
end


if nargin<2 
    % true indicates minimise and false maximise
    s= true(size(list));
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

sse= mse*df;
% assume df= nObs-p
nObs= df+numParams(m);

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
            % Durban-Watson

            delmat = get( m, 'OrderAndDelay' );
            md = max( sum( delmat, 1 ) );

            yhat= eval(m,X,repmat(y(1),md-1,1));
            r= y - yhat;
            s(i)= sum( (r(1:end-1)- r(2:end)).^2 ) /sum(r.^2);
    end
end
