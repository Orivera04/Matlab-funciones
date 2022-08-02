%  sole1.m
% Matlab file for Part 1 of the Systems of Linear 
% Equations module

disp('**********************************************')
disp('Part 1: Unique Solutions ')
disp('**********************************************')
disp('  ')    

    format rational
    
    disp('--------------------------------------------')
    disp('Step 1: ') 
    disp('Solve the system using a technique from the')
    disp('MATLAB Helper Tutorial')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')
    
    disp('---------------------------------------------')
    disp('Step 2: ')
    disp('Here''s another method for solving the system')
    disp('using reduction to row echelon form.')
    disp('  (Note:  The remark about row vectors')
    disp('   being treated as columns is not true for')
    disp('   MATLAB.  Vector b becomes a column vector')
    disp('   below because we transpose a row vector.) ')
    disp(' ')
    disp('Enter: ')
    disp(' ')
    disp('  A = [2   8  6 ')
    disp('       4   2 -2 ')
    disp('       3  -2  1] ')
    disp('  b = [20 -2 11]'' ')
    disp('  M = [A, b]   % Augmented matrix ')
    disp('  R = rref(M) ')
    disp(' ')
    disp('------------------------------------------------')
    disp('The system of equations corresponding to matrix R')
    disp('is equivalent to the original system.  It is: ')
    disp(' ')
    disp('    x1          =  11/6 ')
    disp('        x2      =  -5/6 ')
    disp('            x3  =  23/6 ')
    disp(' ')
    disp('Now it''s easy to read off the solution to the system.')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')
    
    disp('------------------------------------------------')
    disp('Step 3')
    disp('Answer the questions using MATLAB comments in your')
    disp('diary file. ')
    disp(' ')
    disp(' ')
    disp('-------------------------------------------- ')
    disp('When you are ready to go on to part 2 ')
    disp('of this module, type: sole2.')
    disp(' ')
