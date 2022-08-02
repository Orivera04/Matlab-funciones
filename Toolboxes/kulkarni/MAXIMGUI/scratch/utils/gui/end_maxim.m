function exit = end_maxim(fig)

% closes all windows 

exit = uimenu(fig, ...
              'Label', sprintf('Exit %s',''),...
              'Tag','end_maxim', ...
              'Callback',['close all hidden;', 'quit_all;']) ;

   
