%  sprtwo2.m
% Matlab file for Part 2 of the Forced Springs module

disp('********************************************')
disp('Part 2:  Beats ')
disp('********************************************')
disp('  ')    

    format short

    disp('From part 1, we have the symbolic solution ') 
    disp('to the initial value problem:')
    disp('  y'''' + k^2 * y = F0*cos(w*t), y(0), y''(0)=0 ')
    disp('It is  '), ysol
    disp(' ')
    disp('Hit any key to continue!')
    pause
    disp(' ')

    disp('-----------------------------------------------')
    disp('Step 1: ')
    disp('Now,  we set w to 4.25, find the new particular')
    disp('solution, and replot the solution y(t) and the ')
    disp('trajectory in the phase plane.')
    T=0:0.01:30;
    disp(' ')
    disp('Enter:')
    disp(' ')
    disp(' w=4.25 ')
    disp(' y=subs(ysol)')
    disp(' figure(1); clf ')
    disp(' ezplot(y,[0,30]) ')
    disp(' yp=diff(y) ')
    disp(' yT=double( subs(y,t,T) ); ')
    disp(' ypT=double( subs(yp,t,T) ); ')
    disp(' figure(2); clf  ')
    disp(' plot(yT,ypT,''r'') ')
    disp(' axis equal')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')
    
    disp('---------------------------------------------')
    disp('Step 1 (cont.): ')
    disp('Change w to 4.5 and then to 4.75 and re-execute ')
    disp('the commands above to plot y(t) and the trajectory.')
    disp(' ')
    disp('---------------------------------------------')
    disp('For each choice of w, describe what you see.')
    disp('Use MATLAB comments in your diary file.')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')
    
    disp('---------------------------------------------')
    disp('Steps 2 and 3:')
    disp('Our simplified symbolic solution ysol from Part 1 ')
    disp('should already be in the required form:')
    ysol
    disp('Explain why the amplitude of the oscillation ')
    disp('increases as the forcing function w gets closer ')
    disp('to the natural frequency k. ')
    disp('Use MATLAB comments in your diary file.')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')
    
    disp('---------------------------------------------')
    disp('Step 4: ')
    disp(' ')
    disp('Rewrite the solution by using the trig identity. ')
    disp('Explain your steps using MATLAB comments in your ')
    disp('diary file. ')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')
    
    disp('---------------------------------------------')
    disp('Step 5: ')
    disp('Answer the question as MATLAB comments in your ')
    disp('diary file. ')
    disp(' ')
    disp(' ')
    disp('-------------------------------------------- ')
    disp('When you are ready to go on to part 3 ')
    disp('of this module, type: sprtwo3.')
    disp(' ')
