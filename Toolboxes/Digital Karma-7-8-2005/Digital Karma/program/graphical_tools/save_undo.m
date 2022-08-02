% Because of the addition of multiple windows to DigitalKarma, undo was
% adjusted from one cell to cells inside a cell to track the undo for each
% window seperatly
clear undomatrix
if exist('a');
    if isempty(undovalue{1,currentwindow});        
        undomatrix{1,1}=a;
        undomatrix{1,2}=totaliterationscompleted;
        undovalue{1,currentwindow}=undomatrix;
    else;
        undomatrix=undovalue{1,currentwindow};
        undomatrix{end+1,1}=a;
        undomatrix{end,2}=totaliterationscompleted;
        undovalue{1,currentwindow}=undomatrix;
    end;
end;
