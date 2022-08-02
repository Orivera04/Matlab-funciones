function [betas]=getAllIndividualBetas(testIndicators, testReturns, regressionParams)
    
    poolSize = size(testIndicators,2);
    betas = nan(1,poolSize);
    
    warning off all;
     for i=1:poolSize
         trialIndicator = testIndicators(:,i);
         if ~any(isnan(trialIndicator))
             tempBeta= getAppropriateStat(testReturns,trialIndicator,regressionParams.errorTreatment,regressionParams.fitType, 'betaVal');
             betas(1,i)=tempBeta(end);
         end
     end
     warning on all;
 end

