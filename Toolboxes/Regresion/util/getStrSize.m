function [strSize]=getStrSize(cellStrIn)
    strSize=1;
    if iscell(cellStrIn) && ~isempty(cellStrIn)
        strSize = numel(cellStrIn);
    end
end
