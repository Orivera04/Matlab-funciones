% inverse1.m

% Matlab file for Part 1 of the Inverses and
% Elementary Matrices module

disp('********************************************')
disp('Part 1:  Properties of Inverses')
disp('********************************************')
disp('  ')    

    format short
    
    A=[4, 36, 9, -1, -3; -7, -48, -12, 1, 4;...
       2, 28, 10, -1, -3; 5, 40, 9, -1, -3;...
       -2, -7, 9, 0, -1];
    B=[-57, -4, 24, 29, -4; 14, 1, -6, -7, 1;...
       -3, 0, 1, 2, 0; 281, 17, -120, -145, 20; ...
       -11, 1, 3, 9, 0];
    disp('The matrices A and B have been entered into ')
    disp('your MATLAB workspace.')
    A
    B
    disp('Do steps 1 and 2 of the worksheet.  Be sure to')
    disp('save your computations and write a response ')
    disp('to the questions as a MATLAB comment in your')
    disp('diary file. ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp('----------------------------------------------')
    disp(' ')
 
    disp('For steps 3 and 4, enter the matrices P and Q ')
    disp('given below.')
    disp(' ')
    disp('Copy the following commands and paste them as')
    disp('a group at a MATLAB prompt, then execute them.')
    disp(' ')
    disp('  P=[1,0,1; 1,1,0] ')
    disp('  Q=[1,-1; -1,2; 0,1] ')
    disp('  ')
    disp('Do the computations, then answer the questions')
    disp('as MATLAB comments in your diary file.')
    disp('  ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp('----------------------------------------------')
    disp(' ')

    disp('For steps 5 and 6, enter the matrices R and S ')
    disp('given below.')
    disp(' ')
    disp('Copy the following commands and paste them as')
    disp('a group at a MATLAB prompt, then execute them.')
    disp(' ')
    disp('  R=[1,2,0,-1,2; 6,2,8,1,-1; 4,5,4,5,1;... ')
    disp('     5,7,4,4,3; 1,0,1,8,1] ')
    disp('  S=[4,1,-3,2,6; 0,1,5,2,1; 3,8,-11,4,6;... ')
    disp('     2,1,-8,7,2; 1,3,-1,4,8] ')
    disp('  ')
    disp('Do the computations of steps 5 and 6. ')  
    disp('Note that the command: rref(M) finds the')
    disp('reduced row echelon form of matrix M.' )
    disp('Also, inv(M)  finds the inverse matrix M.')
    disp('  ')
    disp('Answer the questions in steps 5 and 6 as')
    disp('MATLAB comments in your diary file.')
    disp('  ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp('----------------------------------------------')
    disp(' ')

    disp('Now, you complete steps 7 and 8 of Part 1.')
    disp(' ')
    disp('Besides your calculations, be sure to include')
    disp('answers to the questions posed as MATLAB ')
    disp('comments in your diary file. ')
    disp(' ')

    disp('----------------------------------------------')
    disp('To go on to part 2 of this module, ')
    disp('type: inverse2')
    disp(' ')