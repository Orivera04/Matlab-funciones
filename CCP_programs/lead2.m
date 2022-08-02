%  lead2.m
% Matlab file for Part 2 of Lead in the Body module

disp('*********************************************')
disp('Part 2:  The Matrix-Vector Formulation ')
disp('*********************************************')
disp('  ')    

    format short

    disp('Steps 1 and 2: ')
    disp('Explain the entries in matrix A and vector b.')
    disp('Use MATLAB comments in your diary file. ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')
 
    disp('----------------------------------------------')
    disp('Step 3: ')
    disp('You can use MATLAB''s symbolic capabilities ')
    disp('to enter and work with matrix A and vector b. ')
    disp(' ')
    disp('Enter: ')
    disp(' ')
    disp('  syms a01 a02 ')
    disp('  syms a21 a12')
    disp('  syms a31 a13 L')
    disp('  A=[-(a01+a21+a31)   a12        a13 ')
    disp('          a21      -(a02+a12)     0  ')
    disp('          a31          0        -a13 ] ')
    disp('  b=[L; 0; 0] ')
    disp('  d=det(A) ')
    disp('  factor(d) ')
    disp(' ')
    disp('-------------------------------------------')
    disp('One way to show a matrix is nonsingular ')
    disp('is to show its determinant is not zero. ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')
 
    disp('----------------------------------------------')
    disp('Step 4: ')
    disp('Find the equilibrium solution xe of ')
    disp('  x'' = A*x + b. ')
    disp('You will probably want to use MATLAB commands')
    disp('applied to matrix A and vector b above. ')
    disp(' ')
    disp('---------------------------------------------')
    disp('Check your answer xe by showing it satisfies')
    disp('the original DE.')
    disp('Suggestion:  To simplify, try a command like ')
    disp('   z = simple( A*xe +b ) ')
    disp(' ')
    disp('---------------------------------------')
    disp('To go on to part 3 of this module,')
    disp('type: lead3 ')
    disp(' ')
    