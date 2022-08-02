%  ppmodel4.m
% Matlab file for Part 4 of the Predator-Prey Models module
% of the Differential Equations section
global a b c p

disp('********************************************')
disp('Part 4:  Varying the Parameters')
disp('********************************************')
disp('  ')    

    format short

    disp('When you hit any key, you will see the')
    disp('direction field of the prey-predator')
    disp('system along with the trajectories we')
    disp('plotted for initial conditions (15,15),')
    disp('(20,20), (25,25), and (30,30) in Part 2.')
    disp(' ')
    disp('The parameters used were a = 1, b = 0.03, ')
    disp('c = 0.4, p = 0.01. ')
    disp(' ')
    disp('Hit any key to continue!')
    pause
    disp(' ')
 
    a=1; b=0.03; c=0.4; p=0.01;
    figure(2); clf; dirfield(0,250,0,150); hold on
    z0=[15,15]'; [t,z]=ode45('de_rhs',[0,12],z0);
    plot(z(:,1),z(:,2),'r')
    z0=[20,20]'; [t,z]=ode45('de_rhs',[0,12],z0);
    plot(z(:,1),z(:,2),'r')
    z0=[25,25]'; [t,z]=ode45('de_rhs',[0,12],z0);
    plot(z(:,1),z(:,2),'r')
    z0=[30,30]'; [t,z]=ode45('de_rhs',[0,12],z0);
    plot(z(:,1),z(:,2),'r')

    disp('---------------------------------------------')
    disp('Step 1:')
    disp('Increase a by 50% and replot.  Compare your ')
    disp('new plot to the plot with the old parameters')
    disp('in the figure 2 window.  Describe the')
    disp('changes you see using MATLAB comments in your')
    disp('diary file.')
    disp(' ')
    disp('Set the parameters and then enter:')
    disp(' ')
    disp(' a = 1 ')
    disp(' b = 0.03 ')
    disp(' c = 0.4 ')
    disp(' p = 0.01 ')
    disp(' figure(1); clf; dirfield(0,250,0,150); hold on ')
    disp(' [t,z]=ode45(''de_rhs'',[0,12], [15,15]''); ')
    disp(' plot(z(:,1), z(:,2), ''r'') ')
    disp(' [t,z]=ode45(''de_rhs'',[0,12], [20,20]''); ')
    disp(' plot(z(:,1), z(:,2), ''r'') ')
    disp(' [t,z]=ode45(''de_rhs'',[0,12], [25,25]''); ')
    disp(' plot(z(:,1), z(:,2), ''r'') ')
    disp(' [t,z]=ode45(''de_rhs'',[0,12], [30,30]''); ')
    disp(' plot(z(:,1), z(:,2), ''r'') ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('------------------------------------------------')
    disp('Step 2: ')
    disp('Return a to its original value of a = 1.')
    disp('Now double b and replot.  Compare your ')
    disp('new plot to the plot with the old parameters')
    disp('in the figure 2 window.  Describe the')
    disp('changes you see using MATLAB comments in your')
    disp('diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')
    
    disp('------------------------------------------------')
    disp('Step 3: ')
    disp('Return b to its original value of b = 0.03.')
    disp('Now double c and replot.  Compare your ')
    disp('new plot to the plot with the old parameters')
    disp('in the figure 2 window.  Describe the')
    disp('changes you see using MATLAB comments in your')
    disp('diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('------------------------------------------------')
    disp('Step 4: ')
    disp('Return c to its original value of c = 0.4.')
    disp('Increase p by 50% and replot.  Compare your ')
    disp('new plot to the plot with the old parameters')
    disp('in the figure 2 window.  Describe the')
    disp('changes you see using MATLAB comments in your')
    disp('diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('-----------------------------------------------')
    disp('Return all parameters to their original values') 
    disp('before going on to the next part.')
    a=1; b=0.03; c=0.4; p=0.01;
    disp(' ')
    disp(' ')
    disp('----------------------------------------------------')
    disp('To go on to part 5 of this module,')
    disp('type: ppmodel5')
    disp(' ')
