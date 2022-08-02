function writeModelArg(fileName, sheetname, paramStruct, fieldArray, MAT_FILE_IO)
    if nargin<5, MAT_FILE_IO=0; end
    if nargin<4 || isempty(fieldArray) || numel(fieldArray)==0, fieldArray = fieldnames(paramStruct); end
    
    outputData=readStructure(paramStruct, fieldArray);
    outputData = outputData';
    myXlSwrite(fileName,outputData,sheetname,MAT_FILE_IO);
end

function [outputData]=readStructure(paramStruct, fieldArray)
    if nargin<2, fieldArray = fieldnames(paramStruct); end
    
    numDataPoints=numel(fieldArray);
    outputData = cell(2,numDataPoints);

    for i=1:numDataPoints
        outputData{1,i}=fieldArray{i};
        temp = getfield(paramStruct, {1,1}, fieldArray{i});
        outputData{2,i}= processedData(temp);
    end
    outputData = outputData';
end

function [str]=processedData(input)
    str = '';
    [r c]=size(input);
    if ischar(input)
        for i=1:r
            str=sprintf('%s',input(i,:));
            if i<r, str = sprintf('%s;',str); end
        end
        return;
    end
    for i=1:r
        for j=1:c
            if iscell(input)
                str = sprintf('%s%s',str,processedData(input{i,j}));
            elseif isa(input,'function_handle')
                str = sprintf('%s%s',func2str(input));
            elseif isstruct(input)
                str = sprintf('%s%s',processedData(readStructure(input)));
            else
                if isnumeric(input(i,j))
                    str = sprintf('%s%g',str,input(i,j));
                else
                    str = sprintf('%s%s',str,input(i,j));
                end
            end
            if j<c, str=sprintf('%s,',str); end
        end
        if i<r, str=sprintf('%s;',str); end
    end
end

