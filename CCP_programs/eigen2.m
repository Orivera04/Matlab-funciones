%  eigen2.m
% Matlab file for Part 2 of the Eigenvalues and 
% Eigenvectors module in the Linear Algebra Collection

disp('*********************************************')
disp('Part 2:  The matrix P ')
disp('*********************************************')
disp('  ')    

    format short

    disp('Here are the matrices A and P from Part 1')
    A
    P 
    disp('---------------------------------------------')   
    disp('Step 1:')
    disp('We check that the first column of P is an')
    disp('eigenvector corresponding to eigenvalue')
    disp('lam=7.')
    disp(' ')
    disp('  v1 = P(:,1) ')
    disp('  A*v1 ')
    disp('  7*v1 ')
    disp(' ')
    disp('---------------------------------------------')
    disp('Check that each column of A is an eigenvector.')
    disp('Use MATLAB comments in your diary file to ')
    disp('answer the question.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Step 2: ')
    disp('The matrix Q below results from exchanging ')
    disp('columns 1 and 2 of P.')
    disp(' ')
    disp('Enter: ')
    disp(' ')
    disp('  Q = [P(:,2), P(:,1), P(:,3)] ')
    disp(' ')
    disp('----------------------------------------------')
    disp('Compute  inv(Q)*A*P  and explain the result.')
    disp('Use MATLAB comments in your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Step 3: ')
    disp('The matrix R below results from multiplying ')
    disp('the columns of P by different scalars.')
    disp(' ')
    disp('Enter: ')
    disp(' ')
    disp('  R = [3*P(:,1), -2*P(:,2), 5*P(:,3)] ')
    disp(' ')
    disp('----------------------------------------------')
    disp('Compute  inv(R)*A*R  and explain the result.')
    disp('Use MATLAB comments in your diary file.')
    disp(' ')
    disp(' ')
    disp('----------------------------------------------')
    disp('To go on to part 3 of this module, ')
    disp('type: eigen3')
    disp(' ')