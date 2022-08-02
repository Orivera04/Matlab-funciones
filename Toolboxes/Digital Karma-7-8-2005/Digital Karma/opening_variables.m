clear; clc;
addpath('program\','saved_files\','program\GUI\','program\graphical_tools\','program\graphical_tools\mouse_click\',...
    'program\graphical_tools\mouseover\','program\graphical_tools\selection_shift\','program\analysis\','program\help\',...
    'program\matrix\','program\matrix\rules\','program\matrix\initial_states\','program\matrix\custom_rules\');


dimension=1; stopiteration=0; stoppedmotionvalue=1;
colorchosen=2; colorreverse=0; colordisplay = flipud(gray);
squareforce=1; suppressdisplay=0; colorbarvalue=0; gridlinesvalue=0;
chooser1value=1; chooser2value=1; casizelimit=0; changersafety=1; making_avi=0;
movetype=['cut']; displaytotaliterations=0; autoscaleon=1; structurenumbersizelimit=1;
currentlyfindandselecting=0; findandselectnext=0;
aselectionstructurenumberstring=0; selectioncoordinates=['a'];% This is for the window when mouse_click_button_move is called after selecting but before aselectionstructurenumberstring is calculated half a second later.
findfeedbackdisplay=0; digitalkarma=gcf; undovalue=cell(1); redovalue=cell(1); beforezoomcell=cell(1);
% savedwindows={a, currentiteration, initial, firstrow, firstcolumn, rows, columns}
savedwindows={1,1,1,1,1,1,1,1,1}; currentwindow=1; iterationdirection=['up'];


displayvalues=0; displaygraphvalues=0; displayselection=0; displayselectionvalues=0; displayallvalues=0; bytevalueson=0;


analysisarealabel=['matrix'];
currentmousetool=['selection']; shiftclickvariable=['move']; selectionshiftbuttondown=0;
currentlyselecting=0; bytevaluemouseover=0; cellvaluemouseover=1; selectionvaluemouseover=1;
selectingbuttondownvalue=0; changerbuttondownvalue=0; panbuttondownvalue=0; wrapbuttondownvalue=0; movebuttondownvalue=0;
