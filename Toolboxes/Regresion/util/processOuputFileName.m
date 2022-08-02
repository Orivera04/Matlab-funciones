function [regressionParams]=processOuputFileName(regressionParams, EXACT_FILE_NAME_FLAG, exactFileName, fileNameArray, assetName)
    outputDir = getStrName(regressionParams.outputDir);
    regressionParams = rmfield(regressionParams, 'outputDir');
    if EXACT_FILE_NAME_FLAG
        fileName = getStrName(exactFileName);
    else
       [pathstr, name] = fileparts(getStrName(fileNameArray));
       fileName = [name '_' assetName '_RESULTS_' datestr(now,'dd-mmm-yyyy HH.MM.SS')];
    end
    regressionParams.outputFileName = fullfile(outputDir,fileName);
end

