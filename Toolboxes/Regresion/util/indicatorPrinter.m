function [subHandle]=indicatorPrinter(indicatorNames)
    myIndicatorNames = [' ',indicatorNames];
    subHandle = @printIndicators;
    function [num]=printIndicators(index)
        tempCol= size(index,2);
        tempRow = size(index,1);
        for i=1:tempRow
            for j=1:tempCol
                fprintf('%s ',(myIndicatorNames{index(i,j)+1}));
            end
            fprintf('\n');
        end
        num=1;
    end
end