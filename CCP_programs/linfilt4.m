%  linfilt4.m
% Matlab file for Part 4 of the Linear Filters 
% module

disp('*****************************************')
disp('Part 4: Passing Frequencies Through')
disp('*****************************************')
disp(' ')    

    format short
  
    disp('Step 1: ')
    disp('You can do this part completely by hand.')
    disp(' ')
    disp('Explain your reasoning and discuss the ')
    disp('significance of what you have found. ')
    disp('Use MATLAB comments in your diary file. ')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')

    keyboard;pi/6
    disp(' ')
       
    disp('-----------------------------------------------')
    disp('Step 2 ')
    disp('The following commands will be useful to you:')
    disp(' ')
    disp('  syms r ')
    disp('  soln = double( solve(r^4 - r^2 + 1) ) ')
    disp('  [theta,R] = cart2pol(real(soln),imag(soln)) ') 
    disp(' ')
    disp('-----------------------------------------------')
    disp('Find the signals that are passed through the ')
    disp('linear filter unchanged.')
    disp(' ')
    disp('Explain all the steps in your solution and give')
    disp('your results by using MATLAB comments in your ')
    disp('diary file. ') 
    disp('(Suggestion:  When comparing to Part 2, look ') 
    disp(' at the decimal form of pi/6.) ')
    disp(' ')
    disp(' ')
    disp('-----------------------------------------------')
    disp('When you are ready to go on to part 5 ')
    disp('of this module, type: linfilt5.')
    disp(' ')
