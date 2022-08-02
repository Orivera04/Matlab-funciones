%  eigen4.m
% Matlab file for Part 4 of the Eigenvalues and 
% Eigenvectors module in the Linear Algebra Collection

disp('*********************************************')
disp('Part 4:  Multiplicities ')
disp('*********************************************')
disp('  ')    

    format short
    
    disp('The matrix X has been entered: ')
    X = [331, 290, -58, 580;  603, 448, -213, 1005;...
        -105, -75, 38, -175; -498, -395, 143, -847]

    disp('The scaling of the matrix is such that more')
    disp('accurate results can be found with MATLAB')
    disp('by using the ''nobalance'' option of ''eig''. ')
    disp(' ')
    disp('Enter:')
    disp(' ')
    disp('  eigvals = eig(X, ''nobalance'') ')
    disp('  [V,D] = eig(X, ''nobalance'') ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Steps 1 and 2: ')
    disp('Answer the questions by using MATLAB comments.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Step 3 and 4: ')
    disp('The following commands may be useful to you. ')
    disp(' ')
    disp('  null( X + 17*eye(4), ''r'') ')
    disp('  rref( X + 17*eye(4) ) ')
    disp(' ')
    disp('Do the calculations and explain using MATLAB')
    disp('comments in your diary file.')
    disp(' ')
    disp(' ')
    disp('----------------------------------------------')
    disp('To go on to part 5 of this module, ')
    disp('type: eigen5')
    disp(' ')