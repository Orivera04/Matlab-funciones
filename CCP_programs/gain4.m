%  gain4.m
% Matlab file for Part 4 of the Gain and Phase Shift
% module

global c k w F0

disp('*****************************************')
disp('Part 4:  Resonant Frequency ')
disp('*****************************************')
disp('  ')    

    format short

    disp('Steps 1 and 2:')
    disp('To differentiate the function M with respect ')
    disp('to w, enter:')
    disp(' ')
    disp('  syms c k w ')
    disp('  M = 1/sqrt( (k^2 - w^2)^2 + 4*c^2*w^2 ) ')
    disp('  Mprime = diff(M, w); ')
    disp('  Mprime = simple(Mprime) ')
    disp('  % Get nice format if big MATLAB window ')
    disp('  pretty(Mprime) ')
    disp(' ')
    disp('---------------------------------------------')
    disp('To solve for the zeros of Mprime, enter:')
    disp(' ')
    disp('  wzeros = solve(Mprime, w) ')
    disp(' ')
    disp('--------------------------------------------')
    disp('Give your formula for the value of w that')
    disp('yield maximum M and your formula for the ')
    disp('maximum value of M.  These formulas will  ')
    disp('depend on c and k. ')
    disp('Explain using MATLAB comments in your diary file. ')
    disp(' ') 
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')
    
    disp('--------------------------------------------')
    disp('Step 3:')
    disp('Are your formulas consistant with earier')
    disp('in this module?  In particular, check whether ')
    disp('your formulas give results consistent with ')
    disp('the graph of M(w) versus w in Part 3, step 3. ')
    disp('Use MATLAB comments in your diary file to discuss.')  
    disp(' ') 
    disp(' ')
    disp('-------------------------------------------- ')
    disp('When you are ready to go on to part 5 ')
    disp('of this module, type: gain5.')
    disp(' ')
