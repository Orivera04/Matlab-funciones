function [foundStr]=CheckDateAvailable(datesArray,testDate)
    
    if length(testDate)~=5
         error('Start date parameter must be of the form MmmYY');
    end 
       
    foundStr=find(strcmpi(cellstr(datestr(datenum(datesArray,'dd/mm/yyyy'),12)),testDate));
    if isempty(foundStr)
        foundStr =0;
    else
        foundStr = foundStr(1);
    end
end
