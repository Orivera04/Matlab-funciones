function writeStructure(fileName, sheetname, inStruct, strfieldName, strArray, fieldArray, MAT_FILE_IO)
    
    if nargin<7, MAT_FILE_IO=0; end
    if nargin<6 || numel(fieldArray)==0 || isempty(fieldArray), fieldArray = fieldnames(inStruct);
        if nargin<5,  strfieldName=[];
            if nargin<3,   error('At least 3 inputs needed to call writeStructure');
            end
        end
    end

    % get data corresponing to each field name 
    % special treatment for data in strfieldName
    % These number are replaced by corres names in strArray
    numDataPoints=numel(fieldArray);
    reShapedStruct = cell(numDataPoints,1);
    for i=1:numDataPoints
        dataOutArray = getStructureMatrix(inStruct,fieldArray{i});
        if sum(strcmp(fieldArray{i},strfieldName))
            strArrayTemp = [' ' strArray(strcmp(fieldArray{i},strfieldName),:)];
            reShapedStruct{i}=reshape(strArrayTemp(dataOutArray+1),size(inStruct,1),[]);
        else
            reShapedStruct{i}=dataOutArray;
        end
    end
    
    %write whole data to a large cell array
    writeArray=[];
    writeArrayHeader=[];
    for i=1:numDataPoints
        
        if iscell(reShapedStruct{i})
            writeArray=[writeArray reShapedStruct{i}];
        else
            writeArray=[writeArray num2cell(reShapedStruct{i})];
        end
        
        %create colum headers using the field names
        num_cols = size(reShapedStruct{i},2);
        if num_cols ==1
            writeArrayHeader = [writeArrayHeader {fieldArray{i}}];
        else
            writeArrayHeader = [writeArrayHeader transpose(strcat(repmat(fieldArray(i),num_cols,1),num2str((1:num_cols)')))];
        end
        
    end
    
    %put headers together with data
    writeArray = [writeArrayHeader; writeArray];
    myXlSwrite(fileName,writeArray,sheetname,MAT_FILE_IO);
end

%function to get the data for a particular field name
function [dataOutArray]=getStructureMatrix(structInArray, fieldName)
    % get the size of the structure and extract data 1-by-1 and put the
    % data in a big matrix dataOutArray. This matrix may be cell arrays or
    % the numbers. Only first data row is picked per structure row
    for i=1:size(structInArray,1);
        temp = getfield(structInArray, {i,1}, fieldName);
        if (iscell(temp))
            dataOutArray(i,1:size(temp{1},2))=temp{1}(1,:);
        else
            dataOutArray(i,1:size(temp,2))=temp(1,:);
        end
    end
end
