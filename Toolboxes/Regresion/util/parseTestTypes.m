function [validRow arrayTemp]=parseTestTypes(inpurString, validTestTypes)
    numTestTypes = numel(validTestTypes);
    arrayTemp = zeros(size(inpurString));
    for i=1:numTestTypes
        arrayTemp = logical(arrayTemp + strcmpi(inpurString,validTestTypes{i}));
    end
    validRow = logical(sum(arrayTemp,2));
end