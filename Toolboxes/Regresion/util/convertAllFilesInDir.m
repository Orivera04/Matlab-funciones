function convertAllFilesInDir(dirPath)
    files = dir(dirPath);
    for i=1:length(files)
        filename=getStrName(files(i).name);
        if isMATResultFile(filename)
            filenameOut=strcat(filename(1:end-3),'XLS');
            index = strfind(filename, '_RESULT');
            if ~isempty(index) && index(1)>0
                filenameOut = strcat(filename(1:(index+6)),'.XLS');
            end
            convertFile(fullfile(dirPath,filename),fullfile(dirPath,filenameOut));
            fprintf(' Converted File: %s.\n',filenameOut);
        end
    end
    fprintf(' Finished.\n');
end

function convertFile(filename,filename2)
    varnames = whos('-file', filename);
    load(filename);
    for i=1:length(varnames)
        eval(strcat('outputWriteData=',varnames(i).name,';'));
        xlswrite(filename2,outputWriteData,varnames(i).name);
    end
end

function [out]=isMATResultFile(filename)
    out=0;
    filename=getStrName(filename);
    if numel(filename)>3 && strcmpi(filename(end-3:end),'.mat')
        out=1;
    end
end
