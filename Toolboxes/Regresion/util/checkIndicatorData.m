function checkIndicatorData(fileNameArray, sheetNameArray, varargin)
    MAT_FILE_IO =0;
    try 
        fprintf('\n\n === Trying Asset: %s \n',getStrName(sheetNameArray));
        loadMultipleFiles(fileNameArray,sheetNameArray, MAT_FILE_IO);
        fprintf('\n  ========= SUCCESS ============ \n\n');
    catch
        fprintf('\n  ========= FAILED ============ \n\n');      
    end
end
    
