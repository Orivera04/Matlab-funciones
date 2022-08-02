%  sprints2.m
% Matlab file for Part 2 of the World Class Sprints
% module

disp('********************************************')
disp('Part 2:  Acceleration, Velocity, Distance ')
disp('********************************************')
disp('  ')    

    format short

    disp('-----------------------------------------------')
    disp('Steps 1-3: ')
    disp('Here is how we can use the symbolic capabilities')
    disp('of MATLAB to define the velocity funcion v, ')
    disp('then substitute values for parameters A and b,')
    disp('and finally make a plot. ')
    disp(' ')
    disp('Enter:')
    disp(' ')
    disp(' syms A b t')
    disp(' vsym=A*b*( 1 - exp(-t/b) ) ')
    disp(' v=subs(vsym, {A,b}, {12.2,0.892})')
    disp(' clf    % Clears figure ')
    disp(' ezplot(v,[0,10]); grid on ')
    disp(' axis([0,10, 0,12]) ')
    disp(' ')
    disp('To continue, type the word return and')
    disp('hit enter!')
    disp(' ')
    keyboard;
    disp(' ')
    
    disp('------------------------------------------------')
    disp('Steps 1-3 (cont): ')
    disp('Now, modify the above commands to generate plots ')
    disp('of the acceleration a and the distance s. ')
    disp(' ')
    disp('When you are done, to continue, type the word')
    disp('return and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')
    
    disp('---------------------------------------------')
    disp('Steps 4 and 5: ')
    disp('Answer the questions as MATLAB comments in your')
    disp('diary file. ')
    disp('Feel free to use MATLAB to do any calculations,')
    disp('or use your calculator.')
    disp(' ')
    disp(' ')
    disp('-------------------------------------------- ')
    disp('When you are ready to go on to Part 3 ')
    disp('of this module, type: sprints3.')
    disp(' ')
