function [pvalues, stats, statWholeModel]=getAllBackwardStatsPvals(testIndicators, testReturns, statname, errorTreatment, fitType, betaCnstFlag, betaConstSz)

    if nargin<7 
        betaConstSz=0; 
        betaCnstFlag=0;
    end
    
    if nargin<5, fitType ='Linear';
        if nargin<4, errorTreatment='STANDARD';
            if nargin<3, statname = 'fstat';
            end
        end
    end
     
    poolSize = size(testIndicators,2);
    stats = zeros(poolSize,1);
    statWholeModel =0;
    temp = ones(1,poolSize);
    
    %If it is pval stat you can get that in one go
    if any(strcmpi(statname,{'pval','betaVal'}))
        pvalues=getAppropriateStat(testReturns,testIndicators,errorTreatment,fitType, statname);
        return;
    end
   
    if betaCnstFlag
        temp=zeros(betaConstSz+1,poolSize);
        for j=1:betaConstSz+1
            temp1 = getAppropriateStat(testReturns(j:end-betaConstSz-1+j,:),testIndicators(j:end-betaConstSz-1+j,:),errorTreatment,fitType, 'betaVal');
            if size(temp1,1)>1, temp1=temp1'; end
            temp(j,:)=sign(temp1);
       end
       temp = temp(1:end-1,:)-temp(2:end,:);
       stats = sum(logical(temp),1);
       pvalues =(stats' ./ betaConstSz);
       return;
    end
                
    for i=1:poolSize
        temp(i)=0;
        stats(i,1)=getAppropriateStat(testReturns,testIndicators(:,logical(temp)),errorTreatment,fitType, statname);
        temp(i)=1;
    end

    statWholeModel=getAppropriateStat(testReturns, testIndicators, errorTreatment, fitType, statname);
    df = numel(testReturns)- size(testIndicators,2)-1;
    pvalues=getAppropriatePvalues(stats, statWholeModel, df, statname);
end

function [pvalues]=getAppropriatePvalues(stats, statWholeModel, df, statname)
    if strcmpi(statname,'fstat')
        pvalues = 1-fcdf(df .*(stats ./ statWholeModel -1),1,(df));
    else %strcmpi(statname,'LL')
        pvalues = 1-chi2cdf(-2*(stats-statWholeModel),1);
    end
end
