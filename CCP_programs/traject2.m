%  traject2.m
% Matlab file for Part 2 of the Trajectories of Linear
% Systems module.
global A

disp('********************************************')
disp('Part 2:  Complex Eigenvalues')
disp('********************************************')
disp('  ')    

    format short

    disp('Using the procedure described in steps 1-4')
    disp('of Part 1 of this module, analyze the')
    disp('trajectories for the linear systems ')
    disp('corresponding to each of the three A matrices')
    disp('listed.')
    disp(' ')
    disp('You will probably want to change the plot')
    disp('window for the direction field and the ')
    disp('initial conditions for your trajectories ')
    disp('for each case. ') 
    disp(' ')
    disp('To see the direction the trajectory moves ')
    disp('as time evolves, you can use the command ')
    disp('   comet( x(:,1), x(:,2) )  ')
    disp('as a replacement for the plot command')
    disp(' ')
    disp('---------------------------------------------')
    disp('Address the issues about direction of spiral')
    disp('and so on.  Explain using MATLAB comments')
    disp('in your diary file. ')
    disp(' ')
    disp('When you have finished, to go on to')
    disp('part 3 of this module, type: traject3')
    disp(' ')