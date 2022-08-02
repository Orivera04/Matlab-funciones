%  logist3.m
% Matlab file for Part 3 of the Logistic Growth module

disp('**********************************************')
disp('Part 3:  Inflection Points and Concavity')
disp('**********************************************')
disp('  ')    

    format short

    disp('Steps 1 and 2:')
    disp('Answer the questions in steps 1 and 2 by using')
    disp('MATLAB comments in your diary file. ')
    disp(' ')
    disp('When you are finished, to continue type the')
    disp('word return and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Step 3:')
    disp('We will use MATLAB''s symbolic capabilities')
    disp('to compute P'''' = DP'' in terms of P.')
    disp(' ')
    disp('Enter:')
    disp(' ')
    disp('  syms r K P ')
    disp('  DP = r*P*(1 - P/K) ')
    disp('  DPprime = diff(DP, P) ')
    disp('  DPprime = factor(DPprime) ')
    disp(' ')
    disp('-----------------------------------------')
    disp('Note that MATLAB doesn''t know that P ')
    disp('is a function of time t.  Thus, to get the')
    disp('correct derivative, you must multiply')
    disp('DPprime by dP/dt == DP from the chain rule')
    disp(' ')
    disp('Use your result to answer the question about')
    disp('the location of the inflection point.')
    disp('Use MATLAB comments in your diary file.')
    disp(' ')
    disp('When you are finished, to continue, type the')
    disp('word return and hit enter! ')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Step 4:')
    disp('Answer the question about the significance of')
    disp('the inflection point using MATLAB comments in')
    disp('your diary file.')
    disp(' ')
    disp(' ')
    disp('----------------------------------------------')
    disp('To go on to Part 4 of this module,')
    disp('type: logist4.')
    disp(' ')


