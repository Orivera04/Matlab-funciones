% inverse3.m

% Matlab file for Part 3 of the Inverses and
% Elementary Matrices module

disp('********************************************')
disp('Part 3:  Singular Matrices ')
disp('********************************************')
disp('  ')    

    format short
    
    disp('The command below will enter a random 5 by 5')
    disp('matrix of integers between -99 and 99 every ')
    disp('time you execute it. ')
    disp('(The command rand(5) gives a 5 by 5 matrix of ')
    disp(' uniform real numbers between 0 and 1.  These ')
    disp(' are then transformed into the integers we want.)')
    disp(' ')
    disp('Copy the following command and paste it at')
    disp('a MATLAB prompt, then execute it.')
    disp(' ')
    disp('  rmat=floor( 99*(2*rand(5)-1) ) ')
    disp(' ')
    disp('Test each random matrix for invertiblity. ')
    disp(' ')
    disp('------------------------------------------- ')
    disp('Do the computations in steps 1 and 2 and')
    disp('answer the questions as MATLAB comments in')
    disp('your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp('----------------------------------------------')
    disp(' ')

    C1=[1,-1,3,3; 2,4,-5,1; -7,1,2,-4; 3,3,1,7];
    disp('For step 3, use matrix C1 below. ')
    C1
    disp(' ')
    disp('Show C1 is singular.')
    disp('Do the computations of steps 3 and 4. ')
    disp('  ')
    disp('Answer the questions in steps 3 and 4 as')
    disp('MATLAB comments in your diary file.')
    disp('  ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp('----------------------------------------------')
    disp(' ')

    disp('Step 5: The matrix C2 below has one missing')
    disp('column with ? as entries.')
    disp(' ')
    disp('Copy and paste the matrix at a MATLAB prompt.')
    disp('Before entering C2, fill in the ''''?'''' in ')
    disp('each row with a number which will make C2')
    disp('singular.  Then enter it.')
    disp(' ')
    disp(' C2=[3,-5,?,2; -1,4,?,1; 1,2,?,3; 1,1,?,4] ')
    disp(' ')
    disp('Do the computations to prove C2 is singular.')
    disp(' ')
   
    disp('----------------------------------------------')
    disp('To go on to part 4 of this module, ')
    disp('type: inverse4')
    disp(' ')