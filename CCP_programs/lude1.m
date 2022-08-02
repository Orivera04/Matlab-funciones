% lude1.m
% Matlab file for Part 1 of the LU Decomposition module

disp('********************************************')
disp('Part 1:  The Basic LU Decomposition')
disp('********************************************')
disp('  ')    

    format short
    
    disp('Enter the matrix A by copying the following ')
    disp('command, pasting it at a MATLAB prompt,')
    disp('and executing it.')
    disp(' ')
    disp('     A=[1,-3,1; 2,-4,2; 2,2,-3]  ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------') 
    disp('Recall that elementary matrices are created by ')
    disp('applying a single row operation to an identity ')
    disp('matrix.  The commands below produce the first')
    disp('such elementary matrix you will need and then')
    disp('apply it to reduce matrix A. ')
    disp('(Note that M(i,:) is the ith row of matrix M.)')
    disp(' ')
    disp('Copy the following commands and paste them as')
    disp('a group at a MATLAB prompt, then execute them.')
    disp(' ')
    disp('     E1=eye(3) ')
    disp('     E1(2,:)=-2*E1(1,:) + E1(2,:) ')
    disp('     A1=E1*A ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Now, you complete steps 1-4 of Part 1.')
    disp(' ')
    disp('Besides your calculations, be sure to include')
    disp('answers to the questions by using MATLAB ')
    disp('comments in your diary file. ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('5.  Included with the m-files that came with ')
    disp('this module is one called lualt.m which contains')
    disp('a function called lualt.  We use it below to')
    disp('do the LU decomposition of A. ')
    disp(' (MATLAB has a built-in LU decomposition function')
    disp(' called lu but it produces a different result')
    disp(' because MATLAB uses row exchanges to reduce')
    disp(' roundoff.  If you use lu, you will find that L')
    disp(' is not a lower triangular matrix.  Its rows have')
    disp(' been permuted.)  ')
    disp(' ')
    disp('Check to see the lualt command gives the same')
    disp('results that you calculated above.')
    disp(' ')
    disp('Enter: ')
    disp(' ')
    disp('  [L,U]=lualt(A) ')
    disp(' ')

    disp('----------------------------------------------')
    disp('To go on to part 2 of this module, ')
    disp('type: lude2')
    disp(' ')