function exit = previous_screen(fig)

% displays Previous Screen menu item

global Next_process Last_process

if strncmp(lower(char(Last_process)), 'maxim_main', 10) == 1
  close_window = 'close all;' ;
else
  close_window = sprintf('close(%d);', fig) ;
end

exit = uimenu(fig, ...
              'Label', 'Previous Screen',...
              'Tag','exit', ...
              'Callback', ['last_to_next;', sprintf('%s', close_window)]) ; 
