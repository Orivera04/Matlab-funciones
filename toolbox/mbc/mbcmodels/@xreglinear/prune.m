function [om,ok]= prune(m);
%PRUNE Prune least squares model from last term
%
%  [OM, OK] = PRUNE(M) creates an optimisation manager that is set up to
%  prune steppable terms from the model starting at the final term. The
%  model configuration with the best criteria value is returned. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.4 $  $Date: 2004/04/04 03:30:08 $

om= contextimplementation(xregoptmgr,m,@i_prune,[],'Prune',@prune);

[s,list]= summary(m);
str= sprintf('%s|',list{:});
om= AddOption(om,'Criteria',list{1},str(1:end-1));
om= AddOption(om,'MinTerms',0,{'int',[1 50]},'Minimum number of terms');% minimum number of terms in model
om= AddOption(om,'Tolerance',0,{'numeric',[0 1000]});% tolerance for prune
om= AddOption(om,'IncludeAll',0,'boolean','Include all terms before prune');% include all terms
om= AddOption(om,'isinitialised',0,'boolean',[],false);% flag to skip initial fit
om= AddOption(om,'Display',0,'boolean',[]);% flag to skip initial fit
ok=1;

function [m,cost,OK,s]= i_prune(m,om,x0,x,y,varargin);


OK=1;
if ~get(om,'isInitialised')
	[m,OK]= leastsq(m,x,y);
end

Criteria= get(om,'Criteria');
nObs= size(x,1);

[ri,s2,df]= var(m);
s2mle= s2*df/nObs;

if get(om,'IncludeAll')
    % All Terms included in model
    InModel = false(size(m));
    [m,OK]= stepwise(m,InModel);
end

MinTerms = get(om,'minterms');
% Convert MinTerms to refer to the minimum number of steppable terms required
MinTerms = max(0, MinTerms - sum(m.TermStatus==1));

% get the stats with all the terms in 
TermsIn = Terms(m);
% Take terms out one at a time.  
tord = termorder(m);
indices = fliplr(tord(:)');
ok = ismember(indices,find(m.TermStatus==3));
indices = indices(ok);

% Make sure that we keep the minimum number of terms required
if MinTerms<=length(indices)
    indices = indices(1:(end-MinTerms));
else
    % There are no spare terms to step out.
    indices = [];
end

s = zeros(length(indices)+1,1);
% first row is current model
s(1,:)=summary(m,Criteria,m.Store.D,m.Store.y); 
np= s;
np(1)= numParams(m);
for i = 1:length(indices);
    [m,OK] = stepwise(m,indices(i));%toggle the state and get the fit 
    np(i+1)= numParams(m);
    if OK
        s(i+1,:)= summary(m,Criteria,m.Store.D,m.Store.y,s2,s2mle);
    else
        s(i+1,:)= NaN;
    end
end


Tol= get(om,'tolerance');

[minCrit,list]= summary(m);
critint= strcmp(list,Criteria);
if minCrit(critint)
    [ms,ind]= min(s(:,1));
    if Tol>0
        tgt= ms + abs(ms)*Tol/100;
        pos= find(s(:,1)<tgt);
        ind= pos(end);
    end
else
    [ms,ind]= max(s(:,1));
    if Tol>0
        tgt= ms - abs(ms)*Tol/100;
        pos= find(s(:,1)>tgt);
        ind= pos(end);
    end
end
    
% fit selected model
TermsIn(indices(1:ind-1))= false;
[m,OK] = stepwise(m,~TermsIn);
cost= s(ind);


if get(om,'Display');
    figure
    plot(np,s(:,1),np(ind),s(ind,1),'*r')
    ylabel(Criteria)
    xlabel('Number of Parameters')
end
