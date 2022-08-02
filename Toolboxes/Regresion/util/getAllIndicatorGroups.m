function [numGroups indicatorGroups]=getAllIndicatorGroups(indicatorOnOff,indicatorPoolSize, grpIndFlag, grpIndNum)
    if nargin<3, grpIndFlag=0;
    end

    %HARDCODE
    ALL_PERMANENT_FLAG = -100;

    if (indicatorPoolSize ~= size(indicatorOnOff,2))
       error(' ERROR: Size of indicatorOnOFF and indicatorData is different.');
    end

    [uniqueArray, temp, indexArray] = unique(indicatorOnOff);
    numGroups = max(indexArray);
    indicatorGroups = zeros(numGroups, indicatorPoolSize);
    
    for i=1:numGroups
        indicatorGroups(i,indexArray==i)=1; 
    end
    
    if (grpIndFlag)
        if (grpIndFlag==1)  % psotive Negative Permanent flag
            if (grpIndNum) %positive numbers - non permament groups
                indicatorGroups = indicatorGroups(uniqueArray>0,:);
            else %negative numbers - permament groups
                uniqueArrayPos = uniqueArray(uniqueArray>0);
                uniqueArrayNeg = uniqueArray(uniqueArray<0);
                indicatorGroupsNeg = zeros(1,indicatorPoolSize);
                
                permanentAllGroups = indicatorGroups(uniqueArray == ALL_PERMANENT_FLAG,:);
                
                szPosAarray = numel(uniqueArrayPos);
                for i=1:szPosAarray
                    indexArray = (abs(uniqueArrayNeg)==uniqueArrayPos(i));
                    if sum(indexArray)==1
                        indicatorGroupsNeg(i,:)= indicatorGroups(uniqueArray == uniqueArrayNeg(indexArray),:);
                        uniqueArrayNeg(indexArray)=[];
                    else
                        indicatorGroupsNeg(i,:)= zeros(1,indicatorPoolSize);
                    end
                    indicatorGroupsNeg(i,:) = logical(sum([indicatorGroupsNeg(i,:); permanentAllGroups],1) );
                end
                
                szNegArray = numel(uniqueArrayNeg);
                for i=1:szNegArray
                    indicatorGroupsNeg(szPosAarray+i,:)= indicatorGroups(uniqueArray == uniqueArrayNeg(i),:);
                end
                indicatorGroups = indicatorGroupsNeg;
            end
            numGroups = size(indicatorGroups,1);
        end
    end
    
end