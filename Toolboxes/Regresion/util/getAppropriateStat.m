function [stat]=getAppropriateStat(testReturns, testIndicatorsIn, errorTreatment, fitType, statname, regressionConstOnOff)
    if strcmpi(fitType,'LOGIT') || strcmpi(fitType,'PROBIT')
        if nargin<6, regressionConstOnOff='off'; end
        %if you ever get hands on calculate here the modified indicators
        %for robust error
        if strcmpi(statname,'betaVal')
            betas=glmfit(testIndicatorsIn,testReturns,'binomial','link',fitType,'constant',regressionConstOnOff);
            stat=betas;
        elseif strcmpi(statname,'pval')
            [betas,dev,stats]=glmfit(testIndicatorsIn,testReturns,'binomial','link',fitType,'constant',regressionConstOnOff);
            stat=stats.p;
        elseif strcmpi(statname,'fstat')
            [betas,dev]=glmfit(testIndicatorsIn,testReturns,'binomial','link',fitType,'constant',regressionConstOnOff);
            stat = -dev./2;
        else %loglikelihood
            [betas,dev]=glmfit(testIndicatorsIn,testReturns,'binomial','link',fitType,'constant',regressionConstOnOff);
            stat = -dev./2;
        end
    else %strcmpi(fitType,'Linear')
        if strcmpi(errorTreatment,'ROBUST')
            [wts, hetroFlag, wtx, wty] = wtdLSRgression([ones(size(testIndicatorsIn,1),1) testIndicatorsIn], testReturns);
        else
            wtx = [ones(size(testIndicatorsIn,1),1) testIndicatorsIn];
            wty = testReturns;          
        end
        
        if strcmpi(statname,'betaVal')
            sz = size(testIndicatorsIn,2);
            betasIn=getRegressionPValues(wtx, wty);
            stat(1:sz,1) = betasIn(2:end);
        elseif strcmpi(statname,'pval')
            sz = size(testIndicatorsIn,2);
            [betasIn, pvaluesIn] =getRegressionPValues(wtx, wty);
            stat(1:sz,1) = pvaluesIn(2:end);
        elseif strcmpi(statname,'fstat')
           [betas, rsq, stat]= getRegressionRsq(wtx, wty);
        else %loglikelihood
           [betas] =  wtx\wty;
           stat = getLL(wty,wtx,betas,fitType);
        end 
    end
end
