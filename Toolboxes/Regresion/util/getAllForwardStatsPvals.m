function [pvalues, stats, statWholeModel]=getAllForwardStatsPvals(testIndicators, trialIndicators, testReturns, statname, errorTreatment, fitType, betaCnstFlag, betaConstSz)
    
    if nargin<8
        betaConstSz=0; 
        betaCnstFlag=0;
    end
    
    if nargin<6, fitType ='Linear';
        if nargin<5, errorTreatment='STANDARD';
            if nargin<4, statname = 'fstat';
            end
        end
    end
    
    poolSize = size(trialIndicators,2);
    stats = zeros(poolSize,1);
    statWholeModel =0;

    for i=1:poolSize
        if betaCnstFlag
            temp=zeros(betaConstSz+1,1);
            for j=1:betaConstSz+1
                temp1 = getAppropriateStat(testReturns(j:end-betaConstSz-1+j,:),[testIndicators(j:end-betaConstSz-1+j,:) trialIndicators(j:end-betaConstSz-1+j,i)],errorTreatment,fitType, 'betaVal');
                temp(j)=sign(temp1(end));
                if temp(j)==0, temp(j)=1; end
            end
            temp = temp(1:end-1)-temp(2:end);
            temp = sum(logical(temp));
        else
            temp=getAppropriateStat(testReturns,[testIndicators trialIndicators(:,i)],errorTreatment,fitType, statname);
        end
        stats(i,1)=temp(end);
    end

    %If it is pval stat then you ave them
    if any(strcmpi(statname,{'pval','betaVal'}))
        pvalues=stats;
        return;    
    end
    
    if strcmpi(statname,'betaConsistent')
        pvalues = stats ./ betaConstSz;
        return;
    end

    statWholeModel = getAppropriateStat(testReturns, testIndicators, errorTreatment, fitType, statname);
    df = numel(testReturns)- size(testIndicators,2);
    pvalues=getAppropriatePvalues(stats, statWholeModel, df, statname);
end

function [pvalues]=getAppropriatePvalues(stats, statWholeModel, df, statname)
    if strcmpi(statname,'fstat')
        pvalues = 1-fcdf(df .*(statWholeModel ./ stats -1),1,(df));
    else %strcmpi(statname,'LL')
        pvalues = 1-chi2cdf(-2*(statWholeModel-stats),1);
    end
end

