function exit = exit_menu(fig)

% function places an Exit menu item on the specified figure
% with a callback to close the program

exit = uimenu(fig, ...
              'Label', sprintf('Exit %s',''),...
              'Tag','exit', ...
              'Callback',['close;', 'quit_all;', ...
                 'close(findobj(''Tag'',''main_figure''));']) ;