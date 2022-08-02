%  sinugr3.m
% Matlab file for Part 3 of the Sinusoidal Graphs
% module

disp('********************************************')
disp('Part 3:  Translations')
disp('********************************************')
disp('  ')    

    format short

    disp('----------------------------------------------')
    disp('Step 1:')
    disp('Answer the questions as MATLAB comments in')
    disp('your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('--------------------------------------------')
    disp('Vertical Translation:')
    disp('Steps 2 and 3:')
    disp('Enter the following commands to plot the ')
    disp('function y=A+sin(t), where A=3.')
    disp(' ')
    disp('     A=3;            ')
    disp('     t=-8:0.1:8;     ')
    disp('     y=A+sin(t);     ')
    disp('     plot(t,y,''b'') ')
    disp('     grid on         ')
    disp(' ')
    disp('--------------------------------------------')  
    disp('Experiment with changing A and replotting. ')
    disp(' ')
    disp('Describe the relation between A and the verical')
    disp('translation of the graph from y=sin(t).')
    disp('Answer using MATLAB comments in your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Steps 4 and 5:')
    disp('Does changing the value of A have any effect')
    disp('on the period of the function?')
    disp(' ')
    disp('What are the y values at the peaks of the')
    disp('function y=A+sin(t)? ')
    disp(' ')
    disp('Does changing the value of A have any effect')
    disp('on the amplitude of the function?  Why or ')
    disp('why not? ')
    disp(' ')
    disp('Answer using MATLAB comments in your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Horizontal Translation:')
    disp('Steps 6 and 7:')
    disp('Enter the following commands to plot the ')
    disp('function y=sin(t) in blue together with')
    disp('the function y=sin(t-t0) in red.')
    disp(' ')
    disp('     clf  %clears figure  ')
    disp('     t0=pi/4     ')
    disp('     t=-8:0.1:8;     ')
    disp('     y=sin(t);   ')
    disp('     plot(t,y,''b'') ')
    disp('     hold on ')
    disp('     y=sin(t-t0);   ')
    disp('     plot(t,y,''r'') ')
    disp('     grid on         ')
    disp(' ')
    disp('--------------------------------------------')  
    disp('Determine the amount and direction of the')
    disp('horizontal translation.')
    disp('This question has more than one answer. How')
    disp('are all possible answers related to t0?')
    disp('Answer using MATLAB comments in your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Step 8:')
    disp('Vary t0 and replot in order to determine')
    disp('the general relationship between t0 and')
    disp('horizontal translation.')
    disp(' ')
    disp('What is the relationship?')
    disp('Answer using MATLAB comments in your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Step 9:')
    disp('Plot the graphs of y=sin(t) and y=cos(t)')
    disp('together.')
    disp(' ')
    disp('Answer the questions in step 9.  Check')
    disp('your answers by plotting. ')
    disp('Answer using MATLAB comments in your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Step 10:')
    disp('Enter your candidate values for A,B,C, and t0')
    disp('into MATLAB')
    disp('    A= ?')
    disp('    B= ?')
    disp('    C= ?')
    disp('    t0= ?')
    disp(' ')
    disp('Then enter the following commands to plot the ')
    disp('function  y = A + B*sin( C*(t-t0) ).')
    disp(' ')
    disp('     clf            ')
    disp('     t=-8:0.1:8;     ')
    disp('     y = A + B*sin( C*(t-t0) );     ')
    disp('     plot(t,y,''b'') ')
    disp('     grid on         ')
    disp(' ')
    disp('--------------------------------------------')  
    disp('What values of A,B,C,and t0 produce a function ')
    disp('with the prescribed properties? ')
    disp(' (Check by plotting.)')
    disp(' ')
    disp('Answer using MATLAB comments in your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Step 11:')
    disp('Change ''''sin'''' to ''''cos'''' in the ')
    disp('commands above for your work on step 11.')
    disp(' ')
    disp('Answer the questions in step 11 and check')
    disp('your answers by plotting.')
    disp('Answer using MATLAB comments in your diary file.')
    disp(' ')
    disp(' ')
    disp('----------------------------------------------')
    disp('To go on to part 4 of this module,') 
    disp('type: sinugr4.')
    disp(' ')