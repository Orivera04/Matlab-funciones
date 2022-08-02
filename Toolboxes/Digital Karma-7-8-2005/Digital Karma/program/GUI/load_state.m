if strcmp(startingstatus,'new');
    if dimension==1;     a=initial1d;
    elseif dimension==2 & exist('initial2d'); a=initial2d;
    end;
elseif strcmp(startingstatus,'load');
    [loadingname, loadingpath]=uigetfile('*.mat','Load Saved State',5,5);
    load([loadingpath,loadingname]); clear undovalue;
end;


if dimension==1 | (dimension==2 & (exist('initial2d') | strcmp(startingstatus,'new')==0));
    computeiterations;
    currentlyselecting=0; totaliterationscompleted=0;
    firstrow=1; firstcolumn=1; columnsshown=columns;
    set(findobj('Tag','columnsinputbox'), 'string', columnsshown);
    if dimension==1; rowsshown=1;     
    elseif dimension==2; rowsshown=totalrows; set(findobj('Tag','rowsinputbox'), 'string', rowsshown); end;
    
    
    if strcmp(startingstatus,'new');
        if exist('rule'); CA_iteration;
        else; clear a; errordlg('Choose Rule','Error'); end;
    else;
        totaliterationscompleted=completediterations;
        currentiteration=0; opening_iteration; CA_Display;
    end;
else;
    errordlg('2-D Initial State not Loaded or Created','Error');
end;