currentlyselecting=0; % deactivates selection so won't be outside another graphs dimensions

% Saves variables
if dimension==1; savedwindows(currentwindow,:)={a, currentiteration, initial1d, firstrow, firstcolumn, rows, columnsshown,low,high};
else; savedwindows(currentwindow,:)={a, currentiteration, initial2d, firstrow, firstcolumn, rowsshown, columnsshown,low,high}; end
set(findobj('Tag',num2str(currentwindow)), 'checked', 'off');

[savedwindowsrows,savedwindowscols]=size(savedwindows);
currentwindow=savedwindowsrows+1;

% creates the new windows menu item
uimenu('Parent',findobj('Tag','windowmenu'),'checked', 'on','Callback','switch_window;','Label',num2str(savedwindowsrows+1),...
    'Tag',num2str(savedwindowsrows+1)); refresh;

% adds a column to the undovalue & redovalue cell matrices
undovalue{1,end+1}=[]; 
redovalue{1,end+1}=[];
beforezoomcell{1,end+1}=[];

computeiterations;
opening_iteration; CA_Display;