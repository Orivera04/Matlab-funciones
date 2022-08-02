function [validCombs]=regressionStepwise(combinationIn, indicatorDataIn, indexReturnsIn, testStartIn, regressionParams, combinationPermanent)
    regressionDataSize = regressionParams.regressionDataSize;
    stepWiseIndicatorFit = regressionParams.stepWiseIndicatorFit;
    fixedStart = strcmpi(regressionParams.fixedStartDate, 'true');
    OLD_STEPWISE_FLAG = strcmpi(regressionParams.OLD_STEPWISE_FLAG,'true');
    indexReturns = indexReturnsIn;
    
    [testPeriodEnd,indicatorPoolSize]=size(indicatorDataIn);

    if isempty(combinationIn), combinationIn = ones(testPeriodEnd,indicatorPoolSize);
    elseif size(combinationIn,1)==1, combinationIn = repmat(combinationIn, testPeriodEnd, 1);
    end
    
    if nargin<6 || isempty(combinationPermanent), combinationPermanent = zeros(testPeriodEnd,indicatorPoolSize);
    elseif size(combinationPermanent,1)==1, combinationPermanent = repmat(combinationPermanent, testPeriodEnd, 1);
    end
    
    if OLD_STEPWISE_FLAG, regressionParams.fitType='linear'; end
    
    if ((strcmpi('logit',regressionParams.fitType) || strcmpi('probit',regressionParams.fitType))) && strcmpi(regressionParams.corRetZeroOne, 'true')
        indexReturns = indexReturns>0;
    end

    % prepare stepwise indicator fit
    swfitType = stepWiseIndicatorFit(1,1);
    stepRegSize = stepWiseIndicatorFit(1,6);
    swfitTypeFwd = swfitType==2;
    swfitTypeBck = swfitType==1;
    swfitTypeBckFwd = ~(logical(swfitTypeFwd+swfitTypeBck));
    firstTimeLoop = 1;

    validCombs=zeros(testPeriodEnd,indicatorPoolSize);
    indicatorStart=max(sum(isnan(indicatorDataIn))+1,sum(isnan(indexReturns)));   %number of nan's per column

    if stepRegSize <= 0, stepRegSize = regressionDataSize;
    end;
    if fixedStart
        stepRegSize = testPeriodEnd;
    end
    if regressionParams.betaConsistentFlag
        stepRegSize=regressionDataSize+regressionParams.betaBacktestSize;
    end
    fprintf('  Total test Periods %d. Starts: %d Ends: %d\n',testPeriodEnd-testStartIn+1,testStartIn,testPeriodEnd);
    %Total test Periods 151. Starts: 25 Ends: 175
    for testPeriod=testStartIn:28   %should be testPeriodEnd
        
        fprintf('    Test Period: %d, ',testPeriod);
        testStart = max(1, testPeriod-stepRegSize);
        indicatorDataAvailable = (indicatorStart <= testStart);    %cols where only 1 date is not available are set to 1
        availableIndicators = indicatorDataAvailable .* logical(combinationIn(testPeriod,:));  %combinationIn is array full of ones
        %for first test period
        permPoolIndicators = indicatorDataAvailable .* logical(combinationPermanent(testPeriod,:));
        inputIndicatorIndex = logical(availableIndicators+permPoolIndicators);
        indicatorData =indicatorDataIn;
   %hardcoded for testing
        regressionParams.betaConsistencyFilter = 'true';
   %end of hardcoding     
        if firstTimeLoop
            if strcmpi(regressionParams.betaConsistencyFilter,'true') 
                betaArray = nan(testPeriodEnd,indicatorPoolSize);
                if (testPeriod-2)>=regressionDataSize     %  tempStart is always 24 until say testperiod = 36, then onwards it increments
                    tempStart = max(regressionDataSize,testPeriod-regressionParams.betaConsistencySize-1);  %betaConsistencySize = 12 indicators
                    for i=tempStart:testPeriod-2     %reaches 12, then always tesperiod-12 to testperiod 
                        betaArray(i,:)=getAllIndividualBetas(indicatorData(i-regressionDataSize+1:i,:),indexReturns(i-regressionDataSize+2:i+1,:),regressionParams);
                       %betas over the last 24 rows before tempstart
                    end
                end
            end
        end
        
        if strcmpi(regressionParams.lagIndicators,'true') && sum(inputIndicatorIndex)>1
             [corInd]=getLaggedCorrelation(indicatorData(1:testPeriod-1,inputIndicatorIndex), indexReturns(1:testPeriod,1), [], 24);
             tempSum =0;
             if ~isempty(corInd)
                 temp = nan(size(inputIndicatorIndex));
                 temp(:,inputIndicatorIndex)=corInd;
                 applicableIndicators = temp <= (testStart-indicatorStart);
                 corInd = temp .* applicableIndicators;
                 if any(corInd)
                     maxLag = max(max(corInd));
                     for i=1:maxLag
                         temp = corInd == i;
                         indicatorData(i+1:end,temp) = indicatorData(1:end-i,temp);
                         indicatorData(1:i,temp)=nan;
                         tempSum = tempSum + sum(temp);
                     end
                 end
             end
             if (regressionParams.debugCommentsL1)
                fprintf('LagIndicators: Lagged(%d/%d), ',tempSum,sum(inputIndicatorIndex));
             end
        end
        
        %Correltion filter needs to be reimplemented, taking care of permament indicator in explicit way
        if strcmpi(regressionParams.correlationFilter, 'true') && sum(inputIndicatorIndex)>1 
            correlationFilterCutoff = regressionParams.correlationFilterCutoff;    
            corrOutMatrix =[];
            if (sum(inputIndicatorIndex)>1 && ~any(isnan(indexReturns(testStart+1:testPeriod,1))))
                corrOutMatrix = getCorrelationRanking([indicatorData(testStart:testPeriod-1,inputIndicatorIndex) indexReturns(testStart+1:testPeriod,1)],correlationFilterCutoff);
            end
            if ~isempty(corrOutMatrix)
                temp = find(inputIndicatorIndex);
                corrOutMatrix = temp(:,corrOutMatrix);
                availableIndicators = availableIndicators - availableIndicators .* indexNumberedToLogical(corrOutMatrix,indicatorPoolSize);
            end
            if (regressionParams.debugCommentsL1), 
                fprintf('Multicollinearity: Removed(%d/%d), ',sum(logical(corrOutMatrix)),sum(inputIndicatorIndex));                  
            end
            inputIndicatorIndex = logical(availableIndicators+permPoolIndicators);
        end
        
           if strcmpi(regressionParams.betaConsistencyFilter,'true') 
             betaArray(testPeriod-1,:)=getAllIndividualBetas(indicatorData(testPeriod-regressionDataSize:testPeriod-1,:),indexReturns(testPeriod-regressionDataSize+1:testPeriod,:),regressionParams);
             betaConsistencySize=regressionParams.betaConsistencySize;
             if testPeriod>=regressionDataSize+betaConsistencySize
                 testArray = betaArray(testPeriod-betaConsistencySize:testPeriod-1,:);
                 testArray =sign(testArray);
                 testArray(testArray==0)=1;
                 betaCstyFilterNumChange = regressionParams.betaCstyFilterNumChange;
                 if strcmpi(regressionParams.betaCstyFilterSignChange,'false')
                     testPostive = sum(testArray==1,1);
                     testNegative = sum(testArray==-1,1);
                     rejectedArray = availableIndicators .* ((testPostive>betaCstyFilterNumChange) & (testNegative>betaCstyFilterNumChange));
                 else
                     testArray = testArray(1:end-1,:)-testArray(2:end,:);
                     testArray(testArray<0)=1;
                     rejectedArray = availableIndicators .* (sum(testArray>0,1)>betaCstyFilterNumChange);
                 end
                 if sum(availableIndicators)-sum(rejectedArray)>stepWiseIndicatorFit(1,5)
                    availableIndicators = availableIndicators .* (1-rejectedArray);
                 else
                     rejectedArray =0;
                 end
                 if (regressionParams.debugCommentsL1), 
                     fprintf('BetaConsistency: Removed(%d/%d), ',sum(logical(rejectedArray)),sum(inputIndicatorIndex));                  
                 end
                 %inputIndicatorIndex = logical(availableIndicators+permPoolIndicators);
             end
        end
        
        availableIndicators = availableIndicators - availableIndicators .* permPoolIndicators;
        inPoolIndicators = zeros(size(availableIndicators));

        testIndicators = indicatorData(testStart:testPeriod-1,:);
        testReturns = indexReturns(testStart+1:testPeriod,1);
        
        if strcmpi(regressionParams.startCarryingPrevMonth, 'true') && ~firstTimeLoop
            inPoolIndicators = validCombs(testPeriod-1,:) .* availableIndicators;
        elseif sum(availableIndicators)>0 && (swfitTypeBckFwd || swfitTypeFwd) && sum(permPoolIndicators)<1
            indicatorPicked = getStartIndicator([testIndicators(:,logical(availableIndicators)) testReturns]);
            temp = find(availableIndicators);
            inPoolIndicators(temp(indicatorPicked))=1;
        else
            inPoolIndicators = availableIndicators;
        end
        outPoolIndicators = availableIndicators - inPoolIndicators;  %outpoolindicators = all remaining indicators
        
        if OLD_STEPWISE_FLAG == 1  
            orderArray = orderByCorrelation(testIndicators,testReturns);
            testIndicators = testIndicators(:,orderArray);
            
            inPoolIndicators = inPoolIndicators(1,orderArray);
            outPoolIndicators = outPoolIndicators(1,orderArray);
            permPoolIndicatorsTemp = permPoolIndicators(1,orderArray);
            
            if size(inPoolIndicators,1)>1, inPoolIndicators=inPoolIndicators'; end
            if size(outPoolIndicators,1)>1, outPoolIndicators=outPoolIndicators'; end
            if size(permPoolIndicatorsTemp,1)>1, permPoolIndicatorsTemp=permPoolIndicatorsTemp'; end
            
            [inPoolIndicatorsOut str]= regressionStepwiseOnDate_OLD(testIndicators, testReturns, inPoolIndicators, outPoolIndicators, permPoolIndicatorsTemp, regressionParams);
            inPoolIndicators = zeros(size(inPoolIndicatorsOut));
            inPoolIndicators(:,orderArray) = inPoolIndicatorsOut;
        else
            [inPoolIndicators str]= regressionStepwiseOnDate(testIndicators, testReturns, inPoolIndicators, outPoolIndicators, permPoolIndicators, regressionParams);
        end
        validCombs(testPeriod,:) = logical(inPoolIndicators+permPoolIndicators);
        fprintf('Completed. Selected %d Indicators. ',sum(inPoolIndicators));
        if (regressionParams.debugCommentsL1), 
            fprintf('%s',str);                  
        end
        fprintf('\n');
        firstTimeLoop=0;
    end
end
     
function [indicatorPicked] = getStartIndicator(testIndicators)
    warning off all;
    temp =  corrcoef(testIndicators); %computes corrl where row = observation, col = variable
    warning on all;
    temp(:,1:end-1)=[];
    temp(end,:)=[];
    temp=abs(temp);
    temp(:,2)=(1:size(temp,1))';
    temp=sortrows(temp,-1);
    indicatorPicked = temp(1,2);
end
