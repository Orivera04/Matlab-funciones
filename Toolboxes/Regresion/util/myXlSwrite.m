function myXlSwrite(fileName, inArray, sheetname, MAT_FILE_IO)
    fprintf('    Writing %s Sheet: ',sheetname);
    if MAT_FILE_IO
        if numel(fileName)<4 || ~strcmpi(fileName(end-3:end),'.MAT')
            fileName=[fileName '.MAT']; 
        end
        str = sprintf('%s=inArray; save(''%s'',''%s''',sheetname,fileName,sheetname);
        fid = fopen(fileName,'r');
        if fid~=-1
            fclose(fid);
            str=sprintf('%s,''-append'');',str);
        else
            str=sprintf('%s);',str);
        end
        eval(str);
    else
        if numel(fileName)<4 ||  ~strcmpi(fileName(end-3:end),'.XLS')
            fileName=[fileName '.XLS']; 
        end
        warning off all;
        xlswrite(fileName,inArray,sheetname);
        warning on all;
    end
    fprintf('Done.\n');
end

