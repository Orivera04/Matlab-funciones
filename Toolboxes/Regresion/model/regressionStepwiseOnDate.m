function [inPoolIndicators str]=regressionStepwiseOnDate(testIndicators, testReturns, inPoolIndicators, outPoolIndicators, permPoolIndicators, regressionParams)
    testResult =1;
    iter = 0;
    MAX_ITER = regressionParams.MAX_ITER;
    str='';
    
    stepWiseIndicatorFit = regressionParams.stepWiseIndicatorFit;

    % prepare stepwise indicator fit
    swfitType = stepWiseIndicatorFit(1,1);
    swfitTypeFwd = swfitType==2;
    swfitTypeBck = swfitType==1;
    swfitTypeBckFwd = ~(swfitTypeFwd | swfitTypeBck);
    
    minNumInd = max(1,stepWiseIndicatorFit(1,4));
    maxNumInd = stepWiseIndicatorFit(1,5);
    if isempty(maxNumInd) || maxNumInd<1 || maxNumInd<minNumInd
        maxNumInd =sum(inPoolIndicators)+sum(outPoolIndicators);
    end
    
    if (strcmpi('logit',regressionParams.fitType) || strcmpi('probit',regressionParams.fitType))
        testReturns = testReturns>0;
    end
    
    warning off all;
    while testResult

        testResultFwd = 0;
        testResultBkwd = 0;

        if sum(outPoolIndicators)>0 && sum(inPoolIndicators)>0 && (swfitTypeBckFwd || swfitTypeFwd) && sum(inPoolIndicators)<maxNumInd
            [indicatorPicked, testResultFwd] = runNextStep(testIndicators(:,logical(inPoolIndicators)), testIndicators(:,logical(outPoolIndicators)), testIndicators(:,logical(permPoolIndicators)), testReturns, regressionParams,  'forward');
        end           %runNextStep is called with the cols of inpoolindicators, and the cols of outpoolindicators
        if testResultFwd
            temp = find(outPoolIndicators);
            inPoolIndicators(temp(indicatorPicked))=1;
            outPoolIndicators(temp(indicatorPicked))=0;
        end                
        % Add the newly picked indicator to the inpool and take it off the outpool
        if (sum(inPoolIndicators)>1 && swfitTypeBckFwd) || (sum(inPoolIndicators)>minNumInd && swfitTypeBck)
            [indicatorPicked, testResultBkwd] = runNextStep(testIndicators(:,logical(inPoolIndicators)), testIndicators(:,logical(outPoolIndicators)), testIndicators(:,logical(permPoolIndicators)), testReturns, regressionParams,  'backward');
        end
        
        if testResultBkwd
            temp = find(inPoolIndicators);
            inPoolIndicators(temp(indicatorPicked))=0;
            outPoolIndicators(temp(indicatorPicked))=1;
        end
        iter = iter+1;
        if (~testResultFwd && ~testResultBkwd) || iter >MAX_ITER   
            if (iter >MAX_ITER), str=sprintf('%sMax Iteration Exceeded, STOPPING STEPWISE, ',str);
            end
            testResult = 0;
        end

    end
    
    countTemp=0;
    while sum(inPoolIndicators) < minNumInd && sum(outPoolIndicators)>0
        [indicatorPicked] = runNextStep(testIndicators(:,logical(inPoolIndicators)), testIndicators(:,logical(outPoolIndicators)), testIndicators(:,logical(permPoolIndicators)), testReturns, regressionParams, 'forward');
        temp = find(outPoolIndicators);
        inPoolIndicators(temp(indicatorPicked))=1;
        outPoolIndicators(temp(indicatorPicked))=0;
        countTemp=countTemp+1;
    end
    if countTemp>0, str=sprintf('%sForcefully Added %d Indicator, ',str,countTemp);
    end
    
    countTemp=0;
    while sum(inPoolIndicators) > maxNumInd
        [indicatorPicked] = runNextStep(testIndicators(:,logical(inPoolIndicators)), testIndicators(:,logical(outPoolIndicators)), testIndicators(:,logical(permPoolIndicators)), testReturns, regressionParams,  'backward');
        temp = find(inPoolIndicators);
        inPoolIndicators(temp(indicatorPicked))=0;
        outPoolIndicators(temp(indicatorPicked))=1;
        countTemp=countTemp+1;
    end
    if countTemp>0, str=sprintf('%sForcefully Dropped %d Indicator, ',str,countTemp);
    end
    
    warning on all;
end

function [indicatorPicked, testResult] = runNextStep(testIndicatorsIn, testIndicatorsTest, permPoolIndicators, testReturns, regressionParams,  stepDir)

    dirfwd = strcmpi('forward',stepDir);

    stepWiseIndicatorFit = regressionParams.stepWiseIndicatorFit;
    errorTreatment = regressionParams.errorTreatment;
    fitType = regressionParams.fitType;
    statTest =regressionParams.statTest;
    statTestWeights =regressionParams.statTestWeights;
    
    numIndicatorsPerm = size(permPoolIndicators,2);
    numTests = numel(statTest);              %number of elements in array (here, only pval)
    
    if regressionParams.betaConsistentFlag
        betaCnstSz = regressionParams.betaBacktestSize;
        testIndicatorsIn2=testIndicatorsIn;
        permPoolIndicators2 = permPoolIndicators;
        testReturns2 = testReturns;
        testIndicatorsTest2 = testIndicatorsTest;

        testIndicatorsIn=testIndicatorsIn(betaCnstSz+1:end,:);
        permPoolIndicators=permPoolIndicators(betaCnstSz+1:end,:);
        testIndicatorsTest=testIndicatorsTest(betaCnstSz+1:end,:);
        testReturns=testReturns(betaCnstSz+1:end,:);
    end

    if (dirfwd)
        numIndicators = size(testIndicatorsTest,2);
        
        if numIndicators<1, error(' ERROR: No indicator to add runNEXTStep');
        end
        
        criteriaArray = zeros(numIndicators,numTests+2);    %ZEROS(rows:num of indicators -  cols:3) 
        criteriaArray(:,1) = transpose(1:numIndicators);    %Then set ITS first col to be the indexes of available indicators
        
        for i=1:numTests
            if strcmpi(statTest(i),'betaConsistent')
                criteriaArray(:,i+1)= getAllForwardStatsPvals([testIndicatorsIn2 permPoolIndicators2], testIndicatorsTest2, testReturns2, statTest(i), errorTreatment, fitType, regressionParams.betaConsistentFlag, betaCnstSz); 
            else
                criteriaArray(:,i+1)= getAllForwardStatsPvals([testIndicatorsIn permPoolIndicators], testIndicatorsTest, testReturns, statTest(i), errorTreatment, fitType); 
            end            %set the second COL of criteriaArray to the forward pvals (indicatorin, allindicators, returns,'pval'..)
            
            if regressionParams.debugCommentsL2
                fprintf('Fwd P Values: (Criteria - %s): ',statTest{i});
                fprintf('%g\n',criteriaArray(:,i+1));
                fprintf('\n');
            end
        end
        %set the third COL to 2nd col
        criteriaArray(:,numTests+2) = criteriaArray(:,2:numTests+1) * transpose(statTestWeights);
        [testResult, indicatorPicked]=runForwardCriteria(criteriaArray, stepWiseIndicatorFit);% ,rem(numIndicators,numTests));
                
    else
        numIndicators = size(testIndicatorsIn,2);
        
        if numIndicators<1, error(' ERROR: No indicator to remove runNEXTStep');
        end
        %create a ZERO (rows = inindicators, cols = 3)
        criteriaArray = zeros(numIndicators+numIndicatorsPerm,numTests+2);
        criteriaArray(:,1) = transpose(1:numIndicators+numIndicatorsPerm);
        %set First COL with indices of the indicators
        for i=1:numTests
            if strcmpi(statTest(i),'betaConsistent')
                criteriaArray(:,i+1)= getAllBackwardStatsPvals([testIndicatorsIn2 permPoolIndicators2], testReturns2, statTest(i), errorTreatment, fitType, regressionParams.betaConsistentFlag, betaCnstSz); 
            else
                trial1 = getAllBackwardStatsPvals([testIndicatorsIn permPoolIndicators], testReturns, statTest(i), errorTreatment, fitType);
                criteriaArray(:,i+1)= trial1(1:end-1,:);
            end

            if regressionParams.debugCommentsL2
                fprintf('Back P Values: (Criteria - %s): ',statTest{i});
                fprintf('%g\n',criteriaArray(:,i+1));
                fprintf('\n');
            end
        end
        
        criteriaArray(numIndicators+1:end,:)=[];
        criteriaArray(:,numTests+2) = criteriaArray(:,2:numTests+1) * transpose(statTestWeights);
        [testResult, indicatorPicked]=runBkwdCriteria(criteriaArray, stepWiseIndicatorFit, rem(numIndicators,numTests));
        
    end
end

function [testResult, indicatorPicked]=runBkwdCriteria(criteriaArray, stepWiseIndicatorFit, funnyStep)
    combPvalLowCutoff= stepWiseIndicatorFit(1,2);
    pvalHighCutoff=stepWiseIndicatorFit(1,3);

    numCriteria = size(criteriaArray,2)-2;
    
    %Next step to iterate between the various criterias
    i=1:numCriteria;
    i=i+funnyStep;
    i = rem(i,numCriteria)+2;

    for j=1:numCriteria
        [indicatorPicked, testResult] = getIndicatorNum(criteriaArray, pvalHighCutoff, i(j), 0);
        if testResult, return
        end
    end
    
    criteriaArray = sortrows(criteriaArray,-(numCriteria+2));
    
    indicatorPicked =criteriaArray(1,1);
    if criteriaArray(1,end)>combPvalLowCutoff || isnan(criteriaArray(1,end))
        testResult = 1;
    else
        testResult = 0;
    end
end

function [testResult, indicatorPicked]=runForwardCriteria(criteriaArray, stepWiseIndicatorFit) % ,funnyStep)
    combPvalLowCutoff= stepWiseIndicatorFit(1,2);
    numCriteria = size(criteriaArray,2)-2;
    
    criteriaArray = sortrows(criteriaArray,(numCriteria+2));
    
    indicatorPicked =criteriaArray(1,1);
    if criteriaArray(1,end)<combPvalLowCutoff 
        testResult = 1;
    else
        testResult = 0;
    end
end

function [indicatorNum testRseult]= getIndicatorNum(criteriaArray, cutOff, colNum, addFlag)
    indicatorNum =0;
    testRseult = 0;
    if addFlag
        criteriaArray = sortrows(criteriaArray,colNum);
        if criteriaArray(1,colNum) < cutOff 
           indicatorNum =criteriaArray(1,1);
           testRseult =1;
        end
    else
        criteriaArray = sortrows(criteriaArray, -colNum);
        if (criteriaArray(1,colNum) > cutOff) || isnan(criteriaArray(1,colNum))
           indicatorNum =criteriaArray(1,1);
           testRseult =1;
        end
    end
end



