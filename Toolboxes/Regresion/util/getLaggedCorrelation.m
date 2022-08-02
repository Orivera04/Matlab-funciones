function [corInd pvalInd correlArray pvalArray timePeriods]=getLaggedCorrelation(dataArray, returnVector, timePeriods, corrSize)
%Remeber that returns should be lagged .. this program assumes dafault lag
%of 1 period, will test whether any use to create further lags
            
    if nargin<3 || isempty(timePeriods), timePeriods = 0:2; end
    if nargin<4 || isempty(corrSize), corrSize = 60; end
    if numel(corrSize)>1, corrSize=corrSize(1); end

    if size(timePeriods,2)>1, timePeriods = timePeriods'; end
    if size(timePeriods,2)>1, error ('TimePeriod should be vector and not a matrix'); end
    
    timePeriods = sortrows(timePeriods,1);
    
    maxCorrSize = min([size(returnVector,1),size(dataArray,1)-timePeriods(end),corrSize]);
    dataSeriesNum = size(dataArray,2);
    correlArray = zeros(1,dataSeriesNum);
    pvalArray = zeros(1,dataSeriesNum);

    warning off all;
    for i=1:size(timePeriods,1)
          [correlArray(i,1:dataSeriesNum) pvalArray(i,1:dataSeriesNum)]=getWtdCorrelationNoCheck(dataArray(1:end-timePeriods(i),:), returnVector, maxCorrSize);
    end
    warning on all;
    
    [maxval,index]=max(abs(correlArray),[],1);
    corInd = transpose(timePeriods(index));
    
    [maxval,index]=min(pvalArray,[],1);
    pvalInd = transpose(timePeriods(index));
    
end

function [correlArray pvalArray]=getWtdCorrelationNoCheck(dataArray, returnVector, sz)
        [correlArray pvalArray]=corr(dataArray(end-sz+1:end,:),returnVector(end-sz+1:end,:),'rows','pairwise');
end
