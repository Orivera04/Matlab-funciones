[savedwindowsrows,savedwindowscols]=size(savedwindows);
if savedwindowsrows>1 & currentwindow~=1;
currentlyselecting=0; % deactivates selection so won't be outside another graphs dimensions

% deletes window menu item
delete(findobj('Tag',num2str(currentwindow))); refresh;
currentwindow=1;

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
set(findobj('Tag',num2str(currentwindow)), 'checked', 'on');

highinputscript; lowinputscript; % this doesn't need to be in gui_display_set run each CA_Display like rowsinputscript
computeiterations; opening_iteration; CA_Display;
end;