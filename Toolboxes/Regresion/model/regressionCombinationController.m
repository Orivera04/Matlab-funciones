function [indicatorCombinationIndex dataStruct]=regressionCombinationController(indicatorData, indexReturns, testStart, regressionParams, indicatorCombinationIn)
          
    
    fprintf('Begin Combinations at %s\n',datestr(now,'dd-mmm-yyyy HH.MM.SS'));  
    % set up variables first
    [testPeriodEnd,indicatorPoolSize]=size(indicatorData);
    if nargin<5, indicatorCombinationIn = ones(testPeriodEnd,indicatorPoolSize);
    elseif size(indicatorCombinationIn,1)==1, indicatorCombinationIn = repmat(indicatorCombinationIn,testPeriodEnd,1);
    end
        
    indicatorChoiceSize = regressionParams.indicatorChoiceSize;
    hitsWindowSize = regressionParams.hitsWindowSize;
    regressionDataSize = regressionParams.regressionDataSize;
    
    fitType = regressionParams.fitType;
    errorTreatment = regressionParams.errorTreatment;

    correlationFilter =strcmpi(regressionParams.correlationFilter, 'true');
    correlationFilterCutoff = regressionParams.correlationFilterCutoff;
         
    
    hits=zeros(testPeriodEnd,1);    
    correlations=zeros(testPeriodEnd,1);         
    dataStruct=struct([]);
    
             
    fprintf('  Indicator Choice Size = %s\n',num2str(indicatorChoiceSize));
    fprintf('  Indicator Pool Size = %s\n',num2str(indicatorPoolSize));   
    
    if numel(indicatorChoiceSize)>1
        indicatorChoiceSize_l=indicatorChoiceSize(1);
        indicatorChoiceSize_u=indicatorChoiceSize(2);
    else
        indicatorChoiceSize_l=indicatorChoiceSize;
        indicatorChoiceSize_u=indicatorChoiceSize;
    end
    indicatorSz = max(indicatorChoiceSize_l,indicatorChoiceSize_u);
     
    indicatorCombinationIndex=zeros(testPeriodEnd,indicatorSz); 
    %The following part runs the cominations on indicator selected above to get min to max no of indicators
    warning off all;
    
    [tempLoopHandle, tempLoopNumber]=bitwiseCombination(indicatorPoolSize,indicatorChoiceSize_l, indicatorChoiceSize_u);
    combStart = now;

    for i=1:tempLoopNumber
        combinationCounter=tempLoopHandle();
        validCombArray = checkValidCombination(combinationCounter,indicatorCombinationIn);
        if sum(validCombArray)>0
            [hitsOut correlationOut]=RunRegressionsOnCombination(testStart,combinationCounter,indicatorData,indexReturns,  testPeriodEnd, regressionDataSize, hitsWindowSize, fitType, errorTreatment, correlationFilter, correlationFilterCutoff);
            
            hitsOut(~validCombArray)=nan;
            correlationOut(~validCombArray)=nan;

            hitCompare1 = (hitsOut>hits);
            hitCompare2 = ((hitsOut==hits) .* (correlationOut > correlations));
            hitCompare = logical(hitCompare1+hitCompare2);

            hits(hitCompare)=hitsOut(hitCompare);
            correlations(hitCompare)=correlationOut(hitCompare);
            sz=size(combinationCounter,2);
            indicatorCombinationIndex(hitCompare,1:sz)=repmat(combinationCounter,sum(hitCompare),1);
            indicatorCombinationIndex(hitCompare,sz+1:indicatorSz)=0;
        end
        if (rem(i,500)==0)
            estTime = (now - combStart)*(tempLoopNumber/i - 1);
            fprintf('  DONE %4.1f%% of %s, Combination %d/%d at %s, Est. Completion: %s,  Time Elapsed %s, Remaining %s.\n',100*(i)/(tempLoopNumber),regressionParams.assetName,i,tempLoopNumber,datestr(now,'HH.MM.SS'),datestr(now+estTime,'HH.MM.SS'),datestr(now-combStart,'HH.MM.SS'), datestr(estTime,'HH.MM.SS'));
        end
    end 
    
    for i=1:testPeriodEnd
        dataStruct = setfield(dataStruct, {i,1}, 'hits', {1},{hits(i,:)}); 
        dataStruct = setfield(dataStruct, {i,1}, 'correlations', {1},{correlations(i,:)});
    end

    warning on all;
    fprintf('Finished Combinations at %s\n\n',datestr(now,'dd-mmm-yyyy HH.MM.SS'));        
end

function [checkResult]=checkValidCombination(indicatorCombination, indicatorCombinationIndex)
    checkResult = sum(indicatorCombinationIndex(:,indicatorCombination),2) == size(indicatorCombination,2);
end
