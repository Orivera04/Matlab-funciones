function [indicatorsArrayOut]=indexNumberedToLogical(indicatorsArrayIn,indicatorPoolSize)
%Function converts Numbered array to Logically index array
    indicatorsArrayOut=zeros(size(indicatorsArrayIn,1),indicatorPoolSize);
    
    for i=1:size(indicatorsArrayOut,1)
        tempArray=indicatorsArrayIn(i,:);
        tempArray(tempArray==0)=[];
        indicatorsArrayOut(i,tempArray)=1;
    end
end
    