%  limpop3.m
% Matlab file for Part 3 of the Limited Population module

disp('*********************************************')
disp('Part 3:  Fruit Flies:  A Numerical Example')
disp('*********************************************')
disp('  ')    

    format short

    disp('First, let''s enter the model parameters.')
    c=input('Enter c, the rate parameter: ');
    c
    M=input('Enter M, the carrying capacity: ');
    M
    p0=input('Enter p0, the initial population: '); 
    p0
    disp(' ')

    disp('----------------------------------------------')    
    disp('Subscripts in MATLAB cannot start at zero.')
    disp('Thus, we need to initialize p(1) to be the')
    disp('initial population p0 and likewise initialize')
    disp('slope(1) to be the initial slope.')
    disp('Let the initial time step be Delta=5 days.')
    disp(' ')
    disp('Copy the following commands and paste them as')
    disp('a group at a MATLAB prompt, then execute them.')
    disp(' ')
    disp('     p(1)=p0; ')
    disp('     slope(1)=c*p(1)*(M-p(1)); ')
    disp('     Delta=5; ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Now we use our recursive definitions to find')
    disp('the next values of population and slope,')
    disp('i.e., compute p(2), then slope(2).') 
    disp(' ')
    disp('Copy the following commands and paste them as')
    disp('a group at a MATLAB prompt, then execute them.')
    disp(' ')
    disp('     p(2)=p(1)+slope(1)*Delta; ')
    disp('     slope(2)=c*p(2)*(M-p(2)); ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('-----------------------------------------------')
    disp('In a like manner, you compute the next two')
    disp('population and slope values.  Note that you')
    disp('must calculate them in the order:') 
    disp('p(3), slope(3), p(4), slope(4)')
    disp(' ')
    disp('When your computions are finished, type: p to')
    disp('see all the populations you have calculated.')
    disp('Likewise, type: slope to see the slopes.')
    disp(' ')
    disp('------------------------------------------------------')
    disp('To go on to part 4 of this module,')
    disp('type: limpop4')
    disp(' ')