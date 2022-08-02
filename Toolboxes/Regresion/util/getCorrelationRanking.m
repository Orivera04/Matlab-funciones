function outMatrix = getCorrelationRanking(inputData, cutOffIn)
    if nargin<2, cutOffIn=0.8;
    end
    
    cutOff = abs(cutOffIn(1,1));

    numIndicators = size(inputData,2)-1;
    dataPoints = size(inputData,1);
    
    if numIndicators<2 || dataPoints<2
        error('Array size less than the lower limit for correl check');
    end
    
    indicatorData = inputData(:,1:numIndicators);
    zeroIndicators = (var(indicatorData)==0 | isnan(var(indicatorData)));
    
    nonConstIndicators = (1:numIndicators) .* (~zeroIndicators);
    nonConstIndicators = nonConstIndicators(nonConstIndicators>0);
    constIndicators = (1:numIndicators) .* (zeroIndicators);
    constIndicators = constIndicators(constIndicators>0);
    constIndicators(1)=0;
    constIndicators = constIndicators(constIndicators>0);
    
    if size(constIndicators,1)>1, constIndicators=constIndicators'; end

    inputData(:,zeroIndicators)=[];
    
    numIndicators = numIndicators- sum(zeroIndicators);
    if numIndicators<2
        error('All the input indicators turned out to be constant');
    end   
    
    correl = abs(corrcoef(inputData));
    returnCorrel = [(1:numIndicators)' correl(1:end-1,end)];
    
    returnCorrel = sortrows(returnCorrel, -2);
    index = returnCorrel(:,1);
    
    inputDataNew = inputData(:,index);
    correl = abs(triu(corrcoef(inputDataNew),1));
    
    outMatrix= getVector(correl > cutOff);

    outMatrix = outMatrix .* (index');
    outMatrix = outMatrix(logical(outMatrix));
    outMatrix = nonConstIndicators(outMatrix);
    outMatrix = [outMatrix constIndicators];
end

function index=getVector(inMat)
    numInd = size(inMat,1);
    index = zeros(1,numInd);
    for i=2:numInd
        temp = sum(inMat(:,i));
        if temp>0
            index(i)=1;
            inMat(i,:)=0;
        end
    end
end
