%  lin2de2.m
% Matlab file for Part 2 of the 2nd Order Linear
% Differential Equations module.
global a b

disp('*********************************************')
disp('Part 2:  The Equation y" + by = 0 with b < 0')
disp('*********************************************')
disp('  ')    

    format short

    disp('Step 1: ')
    disp('In this part, we continue with a = 0:')
    a=0
    disp(' ')
    disp('Given a value of b, the following commands will')
    disp('solve the DE and plot the solution. Use them')
    disp('to make the graphs for various b values. ')
    disp('  (To better observe the changes in the')
    disp('   graphs, we have used the ''''hold on'''' ')
    disp('   command to overlay graphs. You may want')
    disp('   to also change colors.  To clear the ')
    disp('   figure window, use ''''clf''''.)')
    disp(' ')
    disp('Enter:')
    disp(' ')
    disp('  b = ?   % Enter your value ')
    disp('  y0 = 1; ')
    disp('  yp0 = 0; ')
    disp('  z0=[y0,yp0]''; ')
    disp('  [t,z]=ode45(''de2_rhs'',[0,4],z0); ')
    disp('   y=z(:,1);  ')
    disp('  plot(t,y,''r''); grid on; hold on ')
    disp(' ')
    disp('----------------------------------------------')
    disp('Describe how the solutions change as b varies.')
    disp('Explain in terms of the symbolic solution.')
    disp('Use MATLAB comments in your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Step 2:')    
    disp('Reset b to -1 and change the initial condition')
    disp('yp0 in the commands above to -1, then to -0.9,')
    disp('and then to -1.1 in order to investigate the ')
    disp('requested cases.')
    disp(' ')
    disp('----------------------------------------------')
    disp('Describe how the solutions change as yp0 assumes')
    disp('values near -1. ')
    disp('Explain in terms of the symbolic solution.')
    disp('Use MATLAB comments in your diary file.')
    disp(' ')
    disp(' ') 
    disp('When your answers are done, to go on to')
    disp('part 3 of this module, type: lin2de3')
    clf
    disp(' ')