%  orthog2.m
% Matlab file for Part 2 of the Orthogonality module

disp('*********************************************')
disp('Part 2:  Orthogonal projections')
disp('*********************************************')
disp('  ')    

    format short
    
    disp('Step 1:')
    disp('Answer the question using MATLAB comments.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')
    
    disp('----------------------------------------------')
    disp('Step 2: ')
    disp('Below, we generate a random vector y in 8-space')
    disp('and find its projection in the direction of A1,')
    disp('the first column of matrix A from Part 1. ')
    disp(' ')
    disp('Enter: ')
    disp(' ')
    disp(' y = floor( 100*(2*rand(8,1)-1) ) ')
    disp(' A1 = A(:,1) ')
    disp(' projA1y = (dot(y,A1)/dot(A1,A1))*A1  ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')

    disp('----------------------------------------------')
    disp('Step 3: ')
    disp('For the same y we generated above, find the  ')
    disp('projection projWy of y on the subspace W.')
    disp('(Hint: First find the projections of y on the ')
    disp('other columns of A.) ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;   
    disp(' ')
    
    disp('----------------------------------------------')
    disp('Step 4: ')
    disp('Write y as the sum of two vector, one in W and')
    disp('one in Wperp.  Explain why there is only one')
    disp('way to do this.')
    disp('Use MATLAB comments to explain. ')
    disp(' ')
    disp(' ')
    disp('----------------------------------------------')
    disp('To go on to part 3 of this module, ')
    disp('type: orthog3')
    disp(' ')