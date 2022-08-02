function [indicatorCombinationIndexFinal]=regressionStepwiseController(indicatorData, indexReturns, testStart, regressionParams, indicatorOnOff)
          
    fprintf('\nBegin Stepwise Process at %s\n',datestr(now,'dd-mmm-yyyy HH.MM.SS')); 

    indicatorCombinationIndex = []; 
    indexCombinationPermanent = [];

    if strcmpi(regressionParams.runPermanent,'true')
        [testPeriodEnd,indicatorPoolSize]=size(indicatorData);
        [numGroups indicatorPermanentGroups] = getAllIndicatorGroups(indicatorOnOff,indicatorPoolSize,1,0);
        indexCombinationPermanent = logical(sum(indicatorPermanentGroups,1));
        if any(indexCombinationPermanent), fprintf('  There are total of %d permananet indicators.\n',sum(indexCombinationPermanent));  end
    end

    if strcmpi(regressionParams.runGroups,'true')
        [testPeriodEnd,indicatorPoolSize]=size(indicatorData);
        
        stepWiseIndicatorFitGroups = regressionParams.stepWiseIndicatorFitGroups;
        stepWiseIndicatorFitOriginal = regressionParams.stepWiseIndicatorFit;
        
        regressionParams.stepWiseIndicatorFit = stepWiseIndicatorFitGroups;
        temp =0;
        if strcmpi(regressionParams.runPermanent,'true'), temp = 1;
        end
        [numGroups indicatorGroups]=getAllIndicatorGroups(indicatorOnOff,indicatorPoolSize,temp,1);
        fprintf('  Number of indicator groups: %d\n',numGroups); 

        indicatorCombinationIndex=zeros(testPeriodEnd,indicatorPoolSize); 
        for i=1:numGroups
            fprintf('   Processing group : %d\n',i);
            temp=[];
            if strcmpi(regressionParams.runPermanent,'true'), temp = indicatorPermanentGroups(i,:);
            end
            temp1 = regressionStepwise(indicatorGroups(i,:), indicatorData, indexReturns, testStart, regressionParams, temp);
            indicatorCombinationIndex = indicatorCombinationIndex + temp1;
        end
        fprintf('   Finished stepwise for all groups\n');
        fprintf('   Starting Final stepwise indicator integration\n');
        regressionParams.stepWiseIndicatorFit = stepWiseIndicatorFitOriginal;
    end
    indicatorCombinationIndexFinal = regressionStepwise(indicatorCombinationIndex, indicatorData, indexReturns, testStart, regressionParams, indexCombinationPermanent);   

    fprintf('  Finished Stepwise at %s\n\n',datestr(now,'dd-mmm-yyyy HH.MM.SS'));
    indicatorCombinationIndexFinal  = indexLogicalToNumbered(indicatorCombinationIndexFinal);
end

