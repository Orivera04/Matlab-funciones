%  predpr4.m
% Matlab file for Part 4 of the Preditor-Prey Models module

disp('********************************************')
disp('Part 4:  Populations as Functions of Time')
disp('********************************************')
disp('  ')    

    format short

    disp('Step 1: ')
    disp('Suppose we would like to plot the prey')
    disp('population as a function of time,')
    disp('and likewise the preditor population')
    disp('as a function of time.')
    disp('Let''s choose the first scenario in')
    disp('which (x0,y0)=(15,15) and look at the')
    disp('populations over two periods.')
    disp(' ')
    disp('First we solve the system over two periods.')
    disp('For efficiency, we will use MATLAB''s')
    disp('build-in numerical DE solver:')
    disp('  [t,z]=ode23(function_name,[t0,tf],z0)')
    disp('        where z0=[x0,y0]'', a column vector ')
    disp('              of initial conditions.')
    disp(' ')
    disp('--------------------------------------------')
    disp('Copy the following commands and paste them as')
    disp('a group at a MATLAB prompt, then execute them.')
    disp(' ')
    disp('  z0=[15,15]''; ')
    disp('  [t,z]=ode23(''de_rhs'',[0,20], z0); ')
    disp('   x=z(:,1);  ')
    disp('   y=z(:,2);  ')
    disp(' ')
    disp('To check, type the variable name: t, which')
    disp('should give times from 0 to 20 used by ode23.')
    disp('Then type the variable name: x to see the')
    disp('corresponding x values.')
    disp('Likewise, you can type y to see those values.') 
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('------------------------------------------------')
    disp('Step 1 (cont.): ')
    disp('Now, let''s look at a plot of the x(t) solution.')
    disp('We will plot the (t,x) pairs connected in red.')
    disp('On the same plot, we will show the y(t) solution.') 
    disp('Let''s plot the (t,y) pairs connected in green.')
    disp(' ')
    disp('Copy the following commands and')
    disp('paste them as a group at a MATLAB prompt')
    disp('to execute them.')
    disp(' ')
    disp('     clf ')
    disp('     plot(t,x,''r'') ')
    disp('     hold on ')
    disp('     plot(t,y,''g'') ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('------------------------------------------------------')
    disp('Steps 1 and 2: ')
    disp('Enter your answers to the questions in steps 1 and 2')
    disp('as MATLAB comments in your diary file.')
    disp(' ') 
    disp(' ') 
    disp('When your answers are done, to go on to')
    disp('part 5 of this module, type: predpr5')
    disp(' ')