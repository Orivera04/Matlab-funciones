%  marpol2.m
% Matlab file for Part 2 of the Marine Pollution module

disp('********************************************')
disp('Part 2:  Plotting the Data')
disp('********************************************')
disp('  ')    

    format short

    disp('We can make a scatter plot of the data')
    disp('pairs (TBT,TI) by using the MATLAB')
    disp('plot command.  We will use little-o''s')
    disp('to mark each data point.')
    disp(' ')
    disp('Copy the following command and paste it at')
    disp('a MATLAB prompt, then execute it.')
    disp(' ')
    disp('  plot(TBT,TI,''o'') ')
    disp(' ')
    disp('There are many choices for plotting symbols')
    disp('besides ''o''.  Experiment with using ''.'', ')
    disp(' ''x'',''+'', and ''*''.')
    disp(' ')
    disp('----------------------------------------------')
    disp('You can choose the color of the plot symbol too.')
    disp('Try making red little-o''s by typing: ')
    disp(' ')
    disp('  plot(TBT,TI,''ro'') ')
    disp(' ')
    disp('Other colors are magenta (''m''), cyan (''c''),')
    disp('green (''g''), blue (''b''), white (''w''),')
    disp('black (''k''), or yellow (''y''). ')
    disp(' ')
    disp('Try making the points green stars.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('You can label the axes and give the plot')
    disp('a title.  Watch how the commands below')
    disp('magically add features to the existing plot.')
    disp(' ')
    disp('Copy the following commands and paste them at')
    disp('a MATLAB prompt, then execute them.')
    disp(' ')
    disp('  xlabel(''TBT (micrograms/gram of tissue)'') ')
    disp('  ylabel(''Thickness Index of Shell'')  ')
    disp('  title(''Thickness versus TBT in Mussels'') ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('You can resize the plot simply by dragging')
    disp('on the figure window boundaries.')
    disp(' ')
    disp('You can specify the x and y ranges for the plot')
    disp('by filling in numbers and entering the command')
    disp('below, after you have made the plot: ')
    disp(' ')
    disp('     axis( [xmin xmax ymin ymin] ) ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Write a brief description of the relationship ')
    disp('that seems to exist between the concentration of')
    disp('TBT in the cells of mussels and the thickness of')
    disp('their shells.  Write as MATLAB comments in ')
    disp('your diary file.')
    disp(' ') 
    disp('When your description is done, to go on to')
    disp('part 3 of this module, type: marpol3.')
    disp(' ')