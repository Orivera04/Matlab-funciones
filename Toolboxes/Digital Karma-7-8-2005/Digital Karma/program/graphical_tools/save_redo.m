% Because of the addition of multiple windows to DigitalKarma, undo was
% adjusted from one cell to cells inside a cell to track the undo for each
% window seperatly
clear redomatrix
if exist('a');
    if isempty(redovalue{1,currentwindow});
        redomatrix{1,1}=a;
        redomatrix{1,2}=totaliterationscompleted;
        redovalue{1,currentwindow}=redomatrix;
    else;
        redomatrix=redovalue{1,currentwindow};
        redomatrix{end+1,1}=a;
        redomatrix{end,2}=totaliterationscompleted;
        redovalue{1,currentwindow}=redomatrix;
    end;
end;