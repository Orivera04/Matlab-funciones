function allowaxestogrow(f);
% 
% Call allowaxestogrow(f) on a figure f with some sub-axes.
% Then, whenever one of the axes is clicked, it immediately grows to 
% the size of the entire window.  When clicked again, it returns to its
% original position.
%
% This is very useful when you have a number of tiny subplots in a figure
% window and would like to be able to visually inspect them with ease.
%
% Written by Matthew Caywood, caywood@gmail.com, 06/2005

ch = get(f,'Children');

% add a ButtonDown event handler to all axis children of figure f
for i = 1:length(ch)
    ax = ch(i);
    if (strcmp(get(ax,'Type'),'axes'))
        set(ax,'ButtonDownFcn',@enlargesubplot);
    end
end

% -------------

function enlargesubplot(src,eventdata)
% callback function for minimized axes

maxaxissize = [0.05 0.05 0.9 0.9];

% change order of parent figure's children so this is drawn on top
f = get(src,'Parent');
ch = get(f,'Children');
newch = [src ; ch(find(src ~= ch))];
set(f,'Children',newch);

% store original position as user data
pos = get(src,'Position');
set(src,'UserData',pos);

% enlarge
set(src,'Position',maxaxissize);

% change callback to shrink
set(src,'ButtonDownFcn',@shrinksubplot);

% -------------

function shrinksubplot(src,eventdata)
% callback function for maximized axes

% restore original position
pos = get(src,'UserData');
set(src,'Position',pos);

% change callback to enlarge
set(src,'ButtonDownFcn',@enlargesubplot);
