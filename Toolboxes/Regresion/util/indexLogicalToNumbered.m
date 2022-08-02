function [indicatorsArrayOut]=indexLogicalToNumbered(indicatorsArrayIn)
%Function converts logical indexed array to smallest possible numbered Array
    temp=repmat(1:size(indicatorsArrayIn,2),size(indicatorsArrayIn,1),1);
    temp=times(logical(indicatorsArrayIn),temp);
    
    indicatorsArrayOut = zeros(size(indicatorsArrayIn,1),1);
    for i=1:size(indicatorsArrayIn,1)
            tempArray = temp(i,logical(temp(i,:)));
            indicatorsArrayOut(i,1:size(tempArray,2)) = tempArray;      
    end
end
    