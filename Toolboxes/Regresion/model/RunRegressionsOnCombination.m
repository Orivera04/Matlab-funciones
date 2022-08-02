function [hit correlation]=RunRegressionsOnCombination(startDate, indicatorCombination,indicatorData,indexReturns,  ...
    testPeriodEnd, regressionDataSize, hitsWindowSize, fitType, errorTreatment, correlationFilter, correlationFilterCutoff)


    testIndicators = indicatorData(:,indicatorCombination);
    indicatorDataStartPoint=max(max(sum(isnan(testIndicators))+1,sum(isnan(indexReturns))));
    testStart=indicatorDataStartPoint+regressionDataSize;
    hitStart=testStart+hitsWindowSize;
    
    hit = zeros(testPeriodEnd,1);
    hitDirection = hit;
    hit(1:testPeriodEnd)=nan;
    correlation=hit;
    forecast=hit;
    forecastDir = hit;
    
    if (hitStart<=testPeriodEnd)
        
        if (startDate>hitStart && startDate<=testPeriodEnd)
            hitStart = startDate;
            testStart = hitStart-hitsWindowSize;
        end

        % this loop represents the backtests for the requested date
        for i=testStart:testPeriodEnd
            testData = testIndicators(i-regressionDataSize:i-1,:);
            forecastData = testIndicators(i,:);
            testReturns = indexReturns(i-regressionDataSize+1:i,1);

            if (correlationFilter)
                corrOutMatrix = getCorrelationRanking([testData testReturns],correlationFilterCutoff);
                if ~isempty(corrOutMatrix)
                    testData(:,corrOutMatrix)=[];
                    forecastData(:,corrOutMatrix)=[];
                end
            end
            
            if strcmpi('logit',fitType)
                testReturns=testReturns>0;
                beta=glmfit(testData,testReturns,'binomial','link','logit','constant','off');
                forecast(i) = glmval(beta,forecastData,'logit','constant','off');
                yhat = glmval(beta,testIndicators,'logit','constant','off');
                temp =  sortrows(yhat,-1);
                indexRank = ceil( mean(testReturns) * regressionDataSize );
                cutOff = temp( indexRank );
                forecastDir(i,1)= ( forecast(i,1) >=  cutOff)*1;
            else
                if (strcmpi(errorTreatment,'ROBUST')) 
                    [wts, hetro, wtx, wty] = wtdLSRgression(([ones(regressionDataSize,1) testData]), testReturns);
                    forecast(i)=([1 forecastData])*(wtx\wty);
                else
                    forecast(i)=([1 forecastData])*(([ones(regressionDataSize,1) testData]) \ testReturns);
                end              
            end
        end

        if strcmpi('logit',fitType)
            hitDirection(testStart:testPeriodEnd-1)=(forecastDir(testStart:testPeriodEnd-1)==(indexReturns(testStart+1:testPeriodEnd)>0))*1;
        else
            hitDirection(testStart:testPeriodEnd-1)=(sign(forecast(testStart:testPeriodEnd-1))==sign(indexReturns(testStart+1:testPeriodEnd)))*1;
        end
        hitDirection = cumsum(hitDirection);
        hit(hitStart:testPeriodEnd)=hitDirection(hitStart-1:testPeriodEnd-1)-hitDirection(hitStart-hitsWindowSize-1:testPeriodEnd-1-hitsWindowSize);
        hit = hit / hitsWindowSize;
        
        temp =corrcoef([forecast(testStart:testPeriodEnd-1,1) indexReturns(testStart+1:testPeriodEnd,1)]);
        correlation(hitStart:testPeriodEnd)=temp(2,1);
    end
end
