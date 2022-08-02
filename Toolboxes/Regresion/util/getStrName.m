function [strName]=getStrName(cellStringIn,index)

    if nargin<2, index=1; end
    
    if isempty(cellStringIn) || ~iscell(cellStringIn)
        strName=cellStringIn;
    else
        strName = cellStringIn{index};
    end
    
end
