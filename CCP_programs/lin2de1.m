%  lin2de1.m
% Matlab file for Part 1 of the 2nd Order Linear
% Differential Equations module.
global a b

disp('*********************************************')
disp('Part 1:  The Equation y" + by = 0 with b > 0')
disp('*********************************************')
disp('  ')    

    format short

    disp('Step 1: ')
    disp('In this part, we set a = 0:')
    a=0
    disp('In this module, we will use MATLAB''s')
    disp('build-in numerical DE solver:')
    disp('  [t,z]=ode45(function_name,[t0,tf],z0)')
    disp('        where z0=[y0,yp0]'', a column vector, ')
    disp('           gives the initial conditions. ')
    disp(' ')
    disp('Given a value of b, the following commands will')
    disp('solve the DE and plot the solution. Use them')
    disp('to make the graphs for various b values. ')
    disp('  (To better observe the changes in the')
    disp('   graphs, we have used the ''''hold on'''' ')
    disp('   command to overlay graphs. You may want')
    disp('   to also change colors.  To clear the ')
    disp('   figure window, use ''''clf'''')')
    disp(' ')
    disp('Enter:')
    disp(' ')
    disp('  b = ?   % Enter your value ')
    disp('  y0 = 1; ')
    disp('  yp0 = 0; ')
    disp('  z0=[y0,yp0]''; ')
    disp('  [t,z]=ode45(''de2_rhs'',[0,15],z0); ')
    disp('   y=z(:,1);  ')
    disp('  plot(t,y,''r''); grid on; hold on ')
    disp(' ')
    disp('----------------------------------------------')
    disp('Describe how the solutions change as b increases.')
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
    disp('Reset b to 1 and change the initial condition')
    disp('y0 in the commands above to 2 and then to -1')
    disp('in order to investigate the requested cases.')
    disp(' ')
    disp('----------------------------------------------')
    disp('Describe how the solutions change as y0 varies.')
    disp('Explain in terms of the symbolic solution.')
    disp('Use MATLAB comments in your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    clf
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Step 3:')    
    disp('Reset y0 to 1 and change the initial condition')
    disp('yp0 in the commands above to 2 and then to 3')
    disp('in order to investigate the requested cases.')
    disp(' ')
    disp('----------------------------------------------')
    disp('Describe how the solutions change as yp0 varies')
    disp('through positive values. ')
    disp('Explain in terms of the symbolic solution.')
    disp('Use MATLAB comments in your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    clf
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Step 4:')    
    disp('Keep y0 = 1 and change the initial condition')
    disp('yp0 in the commands above to -2 and then to -3')
    disp('in order to investigate the requested cases.')
    disp(' ')
    disp('----------------------------------------------')
    disp('Describe how the solutions change as yp0 varies')
    disp('through negative values. ')
    disp('Explain in terms of the symbolic solution.')
    disp('Use MATLAB comments in your diary file.')
    disp(' ')
    disp(' ') 
    disp('When your answers are done, to go on to')
    disp('part 2 of this module, type: lin2de2')
    clf
    disp(' ')