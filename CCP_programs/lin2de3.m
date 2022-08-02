%  lin2de3.m
% Matlab file for Part 3 of the 2nd Order Linear
% Differential Equations module.
global a b

disp('*********************************************')
disp('Part 3:  The Equation y" + ay + by = 0 with ')
disp('           Nonzero a ')
disp('*********************************************')
disp('  ')    

    format short

    disp('Step 1: ')
    disp('In this part, we keep b=1, y0=1, and yp0=0.')
    b=1,y0=1,yp0=0
    disp(' ')
    disp('Given a value of a, the following commands will')
    disp('solve the DE and plot the solution. Use them')
    disp('to make the graphs for various a values. ')
    disp('  (To better observe the changes in the')
    disp('   graphs, we have used the ''''hold on'''' ')
    disp('   command to overlay graphs. You may want')
    disp('   to also change colors.  To clear the ')
    disp('   figure window, use ''''clf''''.)')
    disp(' ')
    disp('Enter:')
    disp(' ')
    disp('  a = ?   % Enter your value ')
    disp('  [t,z]=ode45(''de2_rhs'',[0,10],[y0,yp0]); ')
    disp('  plot(t, z(:,1), ''r''); grid on; hold on; ')
    disp('  axis([0,10,-1,1]) ')
    disp(' ')
    disp('----------------------------------------------')
    disp('Describe how the solutions change as a varies')
    disp('through positive values. ')
    disp('Explain in terms of the symbolic solution.')
    disp('Use MATLAB comments in your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    clf;
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Step 2:')    
    disp('Set a to -0.25, then to -0.50, and then to -0.75')
    disp('in order to investigate the requested cases. ')
    disp(' ')
    disp('Remove the y range by omitting the line ')
    disp('''''axis([0,10,-1,1])'''' in the plot commands.')
    disp(' ')
    disp('----------------------------------------------')
    disp('Describe how the solutions change as a varies')
    disp('through negative values. ')
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
    disp('Set a to -1.  Change the ''''[0,10]'''' in the')
    disp('''''[t,z]=ode45(''de2_rhs'',[0,10],[y0,yp0])'''' ')
    disp('to other time intervals requested and replot each')
    disp('time.')
    disp(' ')
    disp('----------------------------------------------')
    disp('Describe the solution graph.')
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
    disp('Decrease a from -1 to -3 in steps or 0.25.')
    disp('Vary the time interval as appropriate in order ')
    disp('to get a good picture of the graph. ')
    disp(' ')
    disp('----------------------------------------------')
    disp('Describe how the solutions change as a varies.')
    disp('over the range of values. ')
    disp('Explain in terms of the symbolic solution.')
    disp('Use MATLAB comments in your diary file.')
    disp(' ')
    disp(' ') 
    disp('When your answers are done, to go on to')
    disp('part 4 of this module, type: lin2de4')
    clf
    disp(' ')