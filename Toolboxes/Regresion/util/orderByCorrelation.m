function orderArray = orderByCorrelation(inputData, inputReturns)
    
    numIndicators = size(inputData,2);
    
    warning off all;
    corrMatrix = corrcoef([inputData inputReturns]);
    warning on all;
    
    corrVector = abs(corrMatrix(1:numIndicators,end));
    corrVector(:,2) = (1:numIndicators)';
    
    nansNumer = isnan(corrVector(:,1));
    corrVector(nansNumer,1)=0;
    
    corrVector = sortrows(corrVector,-1);
    orderArray = corrVector(:,2);
    
    orderArray = orderArray';
end

