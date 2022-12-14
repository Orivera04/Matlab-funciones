%  gain2.m
% Matlab file for Part 2 of the Gain and Phase Shift
% module

global c k w F0

disp('*****************************************')
disp('Part 2:  Finding Gain and Phase Shift ')
disp('*****************************************')
disp('  ')    

    format short

    disp('Throughout this part, we set F0=1 and use')
    disp('fixed values of the parameters c and k ')
    disp('which you will solve for in Part 3.')
    F0=1; c=0.17; k=1.3788;
    disp(' ')
    disp('--------------------------------------------') 
    disp('We use the ode45 numerical integrator to ')
    disp('solve the damped forced oscillator IVP: ')
    disp('  [t,z]=ode45(function_name,[t0,tf],z0)')
    disp('        where z0=[y0,yp0]'', a column vector, ')
    disp('           gives the initial conditions. ')
    disp(' ')
    disp('The function that evaluates the right hand side')
    disp('of the system corresponding to the DE is ')
    disp('provided with this module in the file fdamp_rhs.m')
    disp('To see the system enter ''''type fdamp_rhs'''' ')
    disp(' ') 
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')
    
    disp('--------------------------------------------')
    disp('Steps 1 and 2:')
    disp('The following commands compute the numerical')
    disp('solution to the IVP and plot the solution ')
    disp('and the input forcing function for forcing ')
    disp('frequency w=0.5')
    disp(' ')
    disp('Enter: ')
    disp(' ')
    disp('  w = 0.5  ')
    disp('  y0 = 0;   ')
    disp('  yp0 = 0; ')
    disp('  [t,z]=ode45(''fdamp_rhs'',[0,40],[y0;yp0]); ')
    disp('  y=z(:,1);  ')
    disp('  clf ')
    disp('  plot(t,y,''r''); grid on; hold on ')
    disp('  fin=F0*cos(w*t); ')
    disp('  plot(t,fin,''b'') ')
    disp('  legend(''output'',''input'') ')
    disp(' ')
    disp('-----------------------------------------------')
    disp('By direct measurements on the graphs, determine')
    disp('the gain M(0.5) and the phase shift phi(0.5) when ')
    disp('w=0.5.  Record the values for later use.')
    disp(' ')
    disp('Tip:  You can change the ''''window'''' in which ')
    disp('you observe your plot to help you measure the time ')
    disp('interval between x-intercepts of the two graphs')
    disp('more accurately.  For example, enter: ')
    disp(' ')
    disp('     axis( [21.9,22.3, -0.1,0.1] ) ')
    disp(' ')
    disp('Note that the time interval between zeros you measure ')
    disp('must be multiplied by w to get the phase shift. ')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')
    
    disp('---------------------------------------------')
    disp('Step 3: ')
    disp('Change the initial conditions y0 and yp0 in the')
    disp('commands of step 2 and replot the graphs.')
    disp('(Leave w=0.5.) ')
    disp(' ') 
    disp('---------------------------------------------')
    disp('Do your measurements confirm that your results')
    disp('in steps 1 and 2 do not depend on y0 and yp0?')
    disp('Discuss using MATLAB comments in your diary file.')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')
    
    disp('---------------------------------------------')
    disp('Step 4: ')
    disp('Set the initial conditions back to y0=0 and')
    disp('yp0=0.')
    disp(' ')
    disp('Change w to each of the values listed in step 4 ')
    disp('and re-execute the plot commands.  For each ')
    disp('value of w, measure M(w) and phi(w) from the ')
    disp('graphs and record these values. ')
    disp('  (You may need to change the time interval')
    disp('   of integration [0,40] to better see the')
    disp('   graphs or adjust your window with ''axis''.) ')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    keyboard;
    disp(' ')

    disp('-----------------------------------------------')
    disp('Step 5: ')
    disp('Use your recorded datat to fill in the lists')
    disp('(vectors) below for Mvals and phivals.  Then ')
    disp('execute the plot commands to make scatter plots ')
    disp('of the data pairs [wvals,Mvals] and [wvals,phivals].')
    disp(' ')
    disp('Complete and enter:')
    disp(' ')
    disp(' wvals=[0.25, 0.50, 0.75, 1.0, 1.5, 2.0, 3.0] ')
    disp(' Mvals=[?,  ?,          ]')
    disp(' phivals=[?,  ?,          ]')
    disp(' figure(1); clf')
    disp(' plot(wvals, Mvals, ''bo''); grid on; hold on ')
    disp(' title(''Gain versus Forcing Frequency'') ')
    disp(' figure(2); clf')
    disp(' plot(wvals, phivals, ''ro''); grid on; hold on ')
    disp(' title(''Phase shift versus Forcing Frequency'') ')
    disp(' ')
    disp('-----------------------------------------------')
    disp('Comment on what you learn from the graphs. ')
    disp('Use MATLAB comments in your diary file. ')
    disp(' ') 
    disp(' ')
    disp('-------------------------------------------- ')
    disp('When you are ready to go on to part 3 ')
    disp('of this module, type: gain3.')
    disp(' ')
