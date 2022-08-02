function  [str]=getExcelColumnNames(colNum)
    fun_handle = @getOneColumnName;
    str = arrayfun(fun_handle,colNum);
end
function [str]=getOneColumnName(colNum)
    str = {'XXXX'};
    if colNum>=1 && colNum<=26
        str = {char(64+colNum)};
    elseif colNum>=27 && colNum<=256
        a = rem(colNum,26);
        if a==0, a=26; end
        b=(colNum-a)/26;
        str = {strcat(char(64+b),char(64+a))};
    end
end


