function returnTicker = getReturnTicker(indicatorTickers)
    returnTicker = indicatorTickers{end};
    %Check the format: Return of 'SPGSCITR Index'
    if any(strfind(lower(returnTicker),'return of ''')==1) && numel(returnTicker)>12
        returnTicker = returnTicker(12:end-1);
    end
end
