function [outputStruct  summaryStruct outputLastMonthStruct anotherOutputStruct goodDataPoint noCombination indicatorEverPicked] = runForecast(indicatorData, indexReturns, testStart, regressionParams, indicatorCombinationIndex, dates, dataStruct )    

    if nargin<7 || isempty(dataStruct), dataStruct =struct([]); end

    fprintf('Start Generating Forecasts\n');
    testPeriodEnd = size(indicatorData,1);

    regressionDataSize = regressionParams.regressionDataSize;
    fitType = regressionParams.forecastFitType;
    errorTreatment = regressionParams.errorTreatment;
    hitsWindowSize = regressionParams.hitsWindowSize;
    fixedStart = strcmpi(regressionParams.fixedStartDate, 'true');
    regressionConstantOnOff = regressionParams.forecastRegConstOnOff;

    % arrays which will contain the results of the predictions
    betas=zeros(testPeriodEnd,size(indicatorCombinationIndex,2));
    forecast=zeros(testPeriodEnd,1);
    cutOff=zeros(testPeriodEnd,1);
    forecastDir=zeros(testPeriodEnd,1);
    direction=zeros(testPeriodEnd,1);
    BbyF=zeros(testPeriodEnd,1);

    rsquared=zeros(testPeriodEnd,1);  
    hetroFlag= zeros(testPeriodEnd,1);  
    logLikelihood=zeros(testPeriodEnd,1);
    fstatistic=zeros(testPeriodEnd,1);
    pvalue=zeros(testPeriodEnd,1);

    noCombination = zeros(testPeriodEnd,1);
    backtestdate = ones(testPeriodEnd,1);
    actualIndexReturns=zeros(testPeriodEnd,1);

    goodDataPoint=0;
    goodDataPointFlag=true;

    % =================================================================
    % Now make the predictions using all the backtested results
    % =================================================================
    warning off all;
    for testPeriod=testStart:28    % hardcoded, should be testPeriodEnd
        
        combinationToForecast=indicatorCombinationIndex(testPeriod,:);
        
        if fixedStart, regressionDataSize = testPeriod-1; end

        if  size(find(combinationToForecast>0),2)<1, noCombination(testPeriod,1)=1;
        else
            if goodDataPointFlag
                goodDataPoint = testPeriod;
                goodDataPointFlag = false;
            end

            % This is the main part for making predictions using the indicators
            backtestdate(testPeriod,1)=testPeriod-regressionDataSize;  %pick col belonging to the combination
            testIndicators = indicatorData(testPeriod-regressionDataSize:testPeriod-1,combinationToForecast(combinationToForecast>0));
            testReturns = indexReturns(testPeriod-regressionDataSize+1:testPeriod,1);
            actualIndexReturns(testPeriod,1)=indexReturns(testPeriod+1,1); 
            forecastIndicators = indicatorData(testPeriod,combinationToForecast(combinationToForecast>0));

            numIndicators = size(testIndicators,2)+1-strcmpi(regressionConstantOnOff,'off');

            if (strcmpi('logit',fitType) || strcmpi('probit',fitType))
                testReturns = testReturns>0;
                actualIndexReturns(testPeriod,1) = actualIndexReturns(testPeriod,1)>0;
                [betas(testPeriod,1:numIndicators)]=glmfit(testIndicators,testReturns,'binomial','link',fitType,'constant',regressionConstantOnOff);
                forecast(testPeriod,1) = glmval(transpose(betas(testPeriod,1:numIndicators)),forecastIndicators,fitType,'constant',regressionConstantOnOff);
                yhat = glmval(transpose(betas(testPeriod,1:numIndicators)),testIndicators,fitType,'constant',regressionConstantOnOff);
                temp =  sortrows(yhat,-1);
                indexRank = ceil( mean(testReturns) * regressionDataSize );
                cutOff(testPeriod,1) = temp( indexRank );
                forecastDir(testPeriod,1)= ( forecast(testPeriod,1) >=  cutOff(testPeriod,1))*1;
                direction(testPeriod,1) = ( forecastDir(testPeriod,1) == actualIndexReturns(testPeriod,1) )*1;
            else
                if (strcmpi(errorTreatment,'ROBUST')) 
                    [wts, hetro, wtx, wty] = wtdLSRgression(myx2fx(testIndicators,regressionConstantOnOff), testReturns);
                    hetroFlag(testPeriod,1)= hetro;
                else
                    wtx = myx2fx(testIndicators,regressionConstantOnOff);   %simply adds a constant for the linear regression
                    wty = testReturns;
                end 
                [betas(testPeriod,1:numIndicators) , pval, rsq]=getRegressionPValues(wtx, wty);
                rsquared(testPeriod,1) = rsq;
                forecast(testPeriod,1) = myx2fx(forecastIndicators,regressionConstantOnOff)*transpose(betas(testPeriod,1:numIndicators));
                BbyF(testPeriod,1:numIndicators) = betas(testPeriod,1:numIndicators) .*myx2fx(forecastIndicators,regressionConstantOnOff);
                direction(testPeriod,1)=(sign(forecast(testPeriod,1))== sign(actualIndexReturns(testPeriod)));
            end

            pval = getAppropriateStat(testReturns, testIndicators, errorTreatment, fitType, 'pval', regressionConstantOnOff);
            pvalue(testPeriod,1:size(pval,1))=pval;
            fstatistic(testPeriod,1) = getAppropriateStat(testReturns, testIndicators, errorTreatment, fitType, 'fstat', regressionConstantOnOff);
            logLikelihood(testPeriod,1) = getAppropriateStat(testReturns, testIndicators, errorTreatment, fitType, 'LL', regressionConstantOnOff); 
        end
    end  
    warning on all;

    % After thsi point there is only writing of results
    fprintf('  Generated Forecast for %d periods.\n',testPeriodEnd-testStart+1-sum(noCombination));
    fprintf('  Finish Generating Forecasts\n');

    if goodDataPointFlag
       error('No prediction was made. maybe data was not sufficicent to make prediction');
    end

    % =================================================================
    % Put all the data that you need printed into this structure
    % ================================================================
    outputStruct = struct([]);
    fieldArray = fieldnames(dataStruct);
    for i=1:testPeriodEnd
        outputStruct = setfield(outputStruct, {i,1}, 'Date', {1},{dates(i,:)});
        outputStruct = setfield(outputStruct, {i,1}, 'BacktestDate', {1},{dates(backtestdate(i,1),:)});
        outputStruct = setfield(outputStruct, {i,1}, 'Forecast', {1},{forecast(i,:)});
        if (strcmpi('logit',fitType) || strcmpi('probit',fitType))
            outputStruct = setfield(outputStruct, {i,1}, 'cutOff', {1},{cutOff(i,:)});
            outputStruct = setfield(outputStruct, {i,1}, 'forecastDir', {1},{forecastDir(i,:)});
        elseif strcmpi('linear',fitType)
            outputStruct = setfield(outputStruct, {i,1}, 'rsquared', {1},{rsquared(i,:)});
            if (strcmpi(errorTreatment,'ROBUST'))
                outputStruct = setfield(outputStruct, {i,1}, 'hetroFlag', {1},{hetroFlag(i,:)});
            end
        end
        outputStruct = setfield(outputStruct, {i,1}, 'Return', {1},{actualIndexReturns(i,:)});
        outputStruct = setfield(outputStruct, {i,1}, 'Direction', {1},{direction(i,:)});
        outputStruct = setfield(outputStruct, {i,1}, 'NumOfIndicators', {1},{sum(indicatorCombinationIndex(i,:)>0)});

        for j=1:numel(fieldArray) % This migth be backtest Hit and correl data
            temp = getfield(dataStruct, {i,1}, fieldArray{j});
            outputStruct = setfield(outputStruct, {i,1}, fieldArray{j}, {1},temp);
        end
        outputStruct = setfield(outputStruct, {i,1}, 'fstatistic', {1},{fstatistic(i,:)});
        outputStruct = setfield(outputStruct, {i,1}, 'logLikelihood', {1},{logLikelihood(i,:)});
        if strcmpi('linear',fitType)
            outputStruct = setfield(outputStruct, {i,1}, 'betaXIndicator', {1},{BbyF(i,:)});
        end
        outputStruct = setfield(outputStruct, {i,1}, 'betas', {1},{betas(i,:)});
        outputStruct = setfield(outputStruct, {i,1}, 'pvalues', {1},{pvalue(i,:)});
        outputStruct = setfield(outputStruct, {i,1}, 'indicators', {1},{indicatorCombinationIndex(i,:)});
    end 

    % Getting the last forecast and the hit%
    direction(1:goodDataPoint-1,:)=[];
    summaryStruct.Asset = regressionParams.assetName;
    summaryStruct.hitsPercent= nan;
    summaryStruct.lastForecast = forecast(end,1);
    
    if (strcmpi('logit',fitType) || strcmpi('probit',fitType))
        summaryStruct.lastCuttOff = cutOff(end,1);
    end
    
    indicatorEverPicked = sum(indexNumberedToLogical(indicatorCombinationIndex,size(indicatorData,2)),1);

    if testPeriodEnd-testStart>0
        summaryStruct.hitsPercent=sum(direction>0)/(size(direction,1)-1);
    end     
    
    %MonthEnd BackTest
    combinationToForecast=indicatorCombinationIndex(testPeriodEnd,:);
    newTestStart = max([1 testPeriodEnd-regressionDataSize-hitsWindowSize]);
    sampleSize = testPeriodEnd-newTestStart-regressionDataSize+1;
    dataSize = testPeriodEnd-newTestStart+1;
    indicatorDataOut = indicatorData(newTestStart:testPeriodEnd,combinationToForecast(combinationToForecast>0));
    returnDataOut=indexReturns(newTestStart+1:testPeriodEnd+1,1);
    if (strcmpi('logit',fitType) || strcmpi('probit',fitType))
        returnDataOut=returnDataOut>0;
    end
    numIndicators = size(indicatorDataOut,2)+1-strcmpi(regressionConstantOnOff,'off');
    betas = zeros(dataSize,numIndicators);
    BbyF = zeros(dataSize,numIndicators);
    forecast = zeros(dataSize,1);
    rsquared = zeros(dataSize,1);
    pvalue = zeros(dataSize,numIndicators);
    cutOff=zeros(dataSize,1);
    forecastDir=zeros(dataSize,1);
    direction=zeros(dataSize,1);
    fstatistic=zeros(dataSize,1);
    logLikelihood=zeros(dataSize,1);
    
    isnanArray = any(isnan(indicatorDataOut),2);
    for i =1:sampleSize
        if ~isnanArray(i)
            testIndicators = indicatorDataOut(i:i+regressionDataSize-1,:);
            forecastIndicators = indicatorDataOut(i+regressionDataSize,:);
            testReturns = returnDataOut(i:i+regressionDataSize-1,1);
            if (strcmpi('logit',fitType) || strcmpi('probit',fitType))
                [betas(i+regressionDataSize,1:numIndicators)]=glmfit(testIndicators,testReturns,'binomial','link',fitType,'constant',regressionConstantOnOff);
                forecast(i+regressionDataSize,1) = glmval(transpose(betas(i+regressionDataSize,:)),forecastIndicators,fitType,'constant',regressionConstantOnOff);
                yhat = glmval(transpose(betas(i+regressionDataSize,:)),testIndicators,fitType,'constant',regressionConstantOnOff);
                temp =  sortrows(yhat,-1);
                indexRank = ceil( mean(testReturns) * regressionDataSize );
                cutOff(i+regressionDataSize) = temp( indexRank );
                forecastDir(i+regressionDataSize)= ( forecast(i+regressionDataSize) >=  cutOff(i+regressionDataSize))*1;
                direction(i+regressionDataSize) = ( forecastDir(i+regressionDataSize,1) == returnDataOut(i+regressionDataSize) )*1;
            else
                if (strcmpi(errorTreatment,'ROBUST')) 
                    [wts, hetro, wtx, wty] = wtdLSRgression(myx2fx(testIndicators,regressionConstantOnOff), testReturns);
                else
                    wtx = myx2fx(testIndicators,regressionConstantOnOff);
                    wty = testReturns;
                end 
                [betas(i+regressionDataSize,1:numIndicators) , pval, rsq]=getRegressionPValues(wtx, wty);
                rsquared(i+regressionDataSize,1) = rsq;
                forecast(i+regressionDataSize,1) = myx2fx(forecastIndicators,regressionConstantOnOff)*transpose(betas(i+regressionDataSize,:));
                BbyF(i+regressionDataSize,1:numIndicators) = betas(i+regressionDataSize,:) .* myx2fx(forecastIndicators,regressionConstantOnOff);
                direction(i+regressionDataSize)=(sign(forecast(i+regressionDataSize,1))== sign(returnDataOut(i+regressionDataSize)));
            end
            fstatistic(i+regressionDataSize,1) = getAppropriateStat(testReturns, testIndicators, errorTreatment, fitType, 'fstat', regressionConstantOnOff);
            logLikelihood(i+regressionDataSize,1) = getAppropriateStat(testReturns, testIndicators, errorTreatment, fitType, 'LL', regressionConstantOnOff); 
            pval = getAppropriateStat(testReturns, testIndicators, errorTreatment, fitType, 'pval', regressionConstantOnOff);
            pvalue(i+regressionDataSize,1:size(pval,1))=pval;
        end
    end
    
    outputLastMonthStruct = struct([]);
    temp = combinationToForecast(combinationToForecast>0);
    sz = numel(temp);
    temp(sz+1:dataSize)=0;
    for i=1:dataSize
        outputLastMonthStruct = setfield(outputLastMonthStruct, {i,1}, 'IndicatorNumber', {1},{i});
        outputLastMonthStruct = setfield(outputLastMonthStruct, {i,1}, 'indicators', {1},{temp(i)});
        outputLastMonthStruct = setfield(outputLastMonthStruct, {i,1}, 'Date', {1},{dates(newTestStart+i-1,:)});
        outputLastMonthStruct = setfield(outputLastMonthStruct, {i,1}, 'Forecast', {1},{forecast(i,:)});
        if (strcmpi('logit',fitType) || strcmpi('probit',fitType))
            outputLastMonthStruct = setfield(outputLastMonthStruct, {i,1}, 'cutOff', {1},{cutOff(i,:)});
            outputLastMonthStruct = setfield(outputLastMonthStruct, {i,1}, 'forecastDir', {1},{forecastDir(i,:)});
        elseif strcmpi('linear',fitType)
            outputLastMonthStruct = setfield(outputLastMonthStruct, {i,1}, 'rsquared', {1},{rsquared(i,:)});
        end
        outputLastMonthStruct = setfield(outputLastMonthStruct, {i,1}, 'LaggedReturn', {1},{returnDataOut(i,:)});
        outputLastMonthStruct = setfield(outputLastMonthStruct, {i,1}, 'Direction', {1},{direction(i,:)});

        outputLastMonthStruct = setfield(outputLastMonthStruct, {i,1}, 'fstatistic', {1},{fstatistic(i,:)});
        outputLastMonthStruct = setfield(outputLastMonthStruct, {i,1}, 'logLikelihood', {1},{logLikelihood(i,:)});
        outputLastMonthStruct = setfield(outputLastMonthStruct, {i,1}, 'IndicatorData', {1},{indicatorDataOut(i,:)});
        outputLastMonthStruct = setfield(outputLastMonthStruct, {i,1}, 'betas', {1},{betas(i,:)});
        if strcmpi('linear',fitType)
            outputLastMonthStruct = setfield(outputLastMonthStruct, {i,1}, 'betaXIndicator', {1},{BbyF(i,:)});
        end
        outputLastMonthStruct = setfield(outputLastMonthStruct, {i,1}, 'pvalues', {1},{pvalue(i,:)});
    end 
    
    dataStart=sum(isnanArray);
    if (strcmpi('logit',fitType) || strcmpi('probit',fitType))
        betaLT =glmfit(indicatorDataOut(dataStart+1:end-1,:),returnDataOut(dataStart+1:end-1),'binomial','link',fitType,'constant',regressionConstantOnOff);
    else
        if (strcmpi(errorTreatment,'ROBUST')) 
            [wts, hetro, wtx, wty] = wtdLSRgression(myx2fx(indicatorDataOut(dataStart+1:end-1,:),regressionConstantOnOff), returnDataOut(dataStart+1:end-1));
        else
             wtx = myx2fx(indicatorDataOut(dataStart+1:end-1,:),regressionConstantOnOff);
             wty = returnDataOut(dataStart+1:end-1);
        end
        betaLT=getRegressionPValues(wtx, wty);
    end
    indicatorAVGLT = mean(indicatorDataOut(dataStart+1:end-1,:));
    indicatorAVGLTName =   strcat('Indicator',num2str(numel(returnDataOut(dataStart+1:end-1))),'MonthsAverage');
    indicatorAVGST = mean(indicatorDataOut(end-regressionDataSize:end-1,:));
    indicatorAVGSTName =   strcat('Indicator',num2str(regressionDataSize),'MonthsAverage');

    betaLTName = strcat('beta',num2str(numel(returnDataOut(dataStart+1:end-1))),'Months');
        
    anotherOutputStruct = struct([]);
    regConst = ~strcmpi(regressionConstantOnOff,'off');
    if regConst
        temp = [0 temp];
        indicatorDataOut = [ones(size(indicatorDataOut,1),1) indicatorDataOut];
        indicatorAVGLT =[1 indicatorAVGLT];
        indicatorAVGST = [1 indicatorAVGST];
         if ~(strcmpi('logit',fitType) || strcmpi('probit',fitType))
             pvalue = [zeros(size(pvalue,1),1) pvalue];
         end
    end
    for i=1:(sz+regConst)
        anotherOutputStruct = setfield(anotherOutputStruct, {i,1}, 'SerialNumber', {1},{i});
        anotherOutputStruct = setfield(anotherOutputStruct, {i,1}, 'indicators', {1},{temp(i)});
        anotherOutputStruct = setfield(anotherOutputStruct, {i,1}, datestr(datenum(dates(end),'dd/mm/yyyy'),12), {1},{indicatorDataOut(end,i)});
        anotherOutputStruct = setfield(anotherOutputStruct, {i,1}, datestr(datenum(dates(end-1),'dd/mm/yyyy'),12), {1},{indicatorDataOut(end-1,i)});
        anotherOutputStruct = setfield(anotherOutputStruct, {i,1}, datestr(datenum(dates(end-2),'dd/mm/yyyy'),12), {1},{indicatorDataOut(end-2,i)});
        anotherOutputStruct = setfield(anotherOutputStruct, {i,1}, indicatorAVGLTName, {1},{indicatorAVGLT(i)});
        anotherOutputStruct = setfield(anotherOutputStruct, {i,1}, indicatorAVGSTName, {1},{indicatorAVGST(i)});
        anotherOutputStruct = setfield(anotherOutputStruct, {i,1}, 'beta', {1},{betas(end,i)});
        anotherOutputStruct = setfield(anotherOutputStruct, {i,1}, betaLTName, {1},{betaLT(i)});
        anotherOutputStruct = setfield(anotherOutputStruct, {i,1}, 'betaXIndicator', {1},{BbyF(end,i)});
        anotherOutputStruct = setfield(anotherOutputStruct, {i,1}, 'pvalues', {1},{pvalue(end,i)});
    end

end

function outArray=myx2fx(inArray, regressionConstantOnOff)
    if strcmpi(regressionConstantOnOff,'off')
        outArray = inArray;
    else
        outArray = x2fx(inArray);
    end
end
