% inverse4.m

% Matlab file for Part 4 of the Inverses and
% Elementary Matrices module

disp('********************************************')
disp('Part 4:  Hilbert Matrices (Optional)')
disp('********************************************')
disp('  ')    

    format short
    
    disp('The first command below will produce the')
    disp('usual MATLAB numerical version of the')
    disp('6 by 6 Hilbert matrix.  The second command')
    disp('gives the symbolic (exact) version. ')
    disp(' ')
    disp('Copy the following commands and paste them')
    disp('at a MATLAB prompt, then execute them.')
    disp(' ')
    disp('  H=hilb(6) ')
    disp('  H_s=sym(H) ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp('----------------------------------------------')
    disp(' ')

    disp('The next commands define and then plot the')
    disp('column vectors of the 3 by 3 Hilbert matrix. ')
    disp(' ')
    disp('Copy the following commands and paste them')
    disp('at a MATLAB prompt, then execute them.')
    disp(' ')
    disp('  H3=hilb(3) ')
    disp('  axis([0 1 0 1 0 1]) ')
    disp('  axis(''ij'') ')
    disp('  line([0,H3(1,1)],[0,H3(2,1)],[0,H3(3,1)]) ')
    disp('  line([0,H3(1,2)],[0,H3(2,2)],[0,H3(3,2)]) ')
    disp('  line([0,H3(1,3)],[0,H3(2,3)],[0,H3(3,3)]) ')
    disp(' ')
    disp('--------------------------------------------')
    disp('Answer the questions in step 2 using MATLAB')
    disp('comments in your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp('----------------------------------------------')
    disp(' ')

    disp('Step 3: Check to see if MATLAB can find the')
    disp('inverse of the 6 by 6 Hilbert matrix H.')
    format long
    disp(' ')
    disp('Copy the following commands and paste them')
    disp('at a MATLAB prompt, then execute them.')
    disp(' ')
    disp('  Hinv=inv(H) ')
    disp('  Hinv*H ')
    disp(' ')
    disp('--------------------------------------------')
    disp('Answer the questions in step 3 using MATLAB')
    disp('comments in your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp('----------------------------------------------')
    disp(' ')

    disp('Step 4: Now find the inverse of the exact')
    disp('(symbolic) 6 by 6 Hilbert matrix H_s.')
    format short
    disp(' ')
    disp('Copy the following commands and paste them')
    disp('at a MATLAB prompt, then execute them.')
    disp(' ')
    disp('  Hinv_s=inv(H_s) ')
    disp('  Hinv_s*H_s ')
    disp(' ')
    disp('--------------------------------------------')
    disp('Answer the questions in step 4 using MATLAB')
    disp('comments in your diary file.')
    disp(' ')

    disp('----------------------------------------------')
    disp('To go on to part 5 of this module, ')
    disp('type: inverse5')
    disp(' ')