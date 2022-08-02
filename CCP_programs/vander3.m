%  vander3.m
% Matlab file for Part 3 of the van der Pol System
% module

global a

disp('*******************************************')
disp('Part 3: Other Nonlinear Systems (Optional) ')
disp('*******************************************')
disp('  ')    

    format short

    disp('Use a text editor to edit the file de_rhs.m ')
    disp('to change the term I*(I^2 - a) to I*(I^3 - a).')
    disp('That is, change ')
    disp('      -z(1)*(z(1)^2 - a) - z(2) ')
    disp('to    -z(1)*(z(1)^3 - a) - z(2). ')
    disp(' ') 
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')
    
    disp('--------------------------------------------')
    disp('Steps 1 thru 3:')
    disp('Use the commands of part 2 to investigate the')
    disp('new system, making the requested calculations')
    disp('and plots. ')
    disp('You may have to change time intervals for ')
    disp('numerical solutions and windows for plotting. ')
    disp(' ')
    disp('--------------------------------------------')
    disp('Answer all questions in steps 1 thru 3 as MATLAB')
    disp('comments in your diary file. ')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('--------------------------------------------')
    disp('Again use a text editor to edit the file de_rhs.m ')
    disp('to change the term I*(I^3 - a) to I*(I^4 - a).')
    disp('That is, change ')
    disp('     -z(1)*(z(1)^3 - a) - z(2)  ')
    disp('to   -z(1)*(z(1)^4 - a) - z(2). ')
    disp(' ') 
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')
    
    disp('--------------------------------------------')
    disp('Now repeat steps 1 thru 3 for the new system.')
    disp(' ') 
    disp(' ')
    disp('-------------------------------------------- ')
    disp('When you are ready to go on to part 4 ')
    disp('of this module, type: vander4.')
    disp(' ')
