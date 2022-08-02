analysis_area;
if exist('analysisarea');
    % Finds unique values in the analysisarea
    uniqueanalysisarea=unique(analysisarea);
    totaluniqueanalysisareasize=prod(size(uniqueanalysisarea));
    for currentvalue=1:totaluniqueanalysisareasize % Puts each unique value starting a row in statsmatrix
        uniqueanalysisareavalues(currentvalue,:)=uniqueanalysisarea(currentvalue);
    end;
    statsmatrix=uniqueanalysisareavalues;
    totalfound=prod(size(analysisarea));
    
    % Counts the unique values in the analysisarea
    for checking=1:length(uniqueanalysisareavalues);
        statsmatrix(checking,2)=nnz(uniqueanalysisareavalues(checking)==analysisarea);
        statsmatrix(checking,3)=roundn(statsmatrix(checking,2)/(totalfound/100),-2);
    end;
    statsmatrix(end+1,:)=[0,totalfound,100];
    statsmatrixheading=[' Values',' Occurances',' %'];
else;
    errordlg('Nothing Selected','Error');
end;
