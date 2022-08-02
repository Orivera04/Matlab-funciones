currentlyselecting=0; % deactivates selection so won't be outside another graphs dimensions

% saves variables
if dimension==1; savedwindows(currentwindow,:)={a, currentiteration, initial1d, firstrow, firstcolumn, rows, columnsshown,low,high};
else; savedwindows(currentwindow,:)={a, currentiteration, initial2d, firstrow, firstcolumn, rowsshown, columnsshown,low,high}; end
set(findobj('Tag',num2str(currentwindow)), 'checked', 'off');

currentwindow=str2num(get(gcbo,'tag'));


% replaces variables
a=savedwindows{currentwindow,1};
currentiteration=savedwindows{currentwindow,2};
if dimension==1; initial1d=savedwindows{currentwindow,3};
else; initial2d=savedwindows{currentwindow,3};end;
firstrow=savedwindows{currentwindow,4};
firstcolumn=savedwindows{currentwindow,5};
set(findobj('Tag','rowsinputbox'), 'string', num2str(savedwindows{currentwindow,6}));
set(findobj('Tag','columnsinputbox'), 'string',num2str(savedwindows{currentwindow,7}));
set(findobj('Tag','lowinput'), 'string',num2str(savedwindows{currentwindow,8}));
set(findobj('Tag','highinput'), 'string',num2str(savedwindows{currentwindow,9}));
set(gcbo, 'checked', 'on');

highinputscript; lowinputscript; % this doesn't need to be in gui_display_set run each CA_Display like rowsinputscript
computeiterations; opening_iteration; CA_Display;


