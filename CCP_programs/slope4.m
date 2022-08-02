%  slope4.m
% Matlab file for Part 4 of the Slope module

disp('********************************************')
disp('Part 4:  Slope Fields for Limited')
disp('         Population Growth')
disp('********************************************')
disp('  ')    

    format short

    close
    disp('In this part, we will attempt to fit')
    disp('the Euler solution we found before')
    disp('in the ''Limited Population Growth''')
    disp('module to the model''s slope field.')
    disp(' ')
    disp('Enter the constants for the limited ')
    disp('growth model.')
    disp(' ')
    M=input('Enter M, the carrying capacity: '); 
    M
    c=input('Enter c, the rate constant: '); 
    c
    
    disp('Using what you have learned in parts 1 and 2:')
    disp('complete the following task: ')
    disp(' ')
    disp('Draw the slope field for the D.E.')
    disp('        dP/dt = c P (M-P) ')
    disp('using the slpfield command.  The time axes')
    disp('should run from 0 to 100 and the Population')
    disp('axis should run from 0 to 1000.')
    disp('     (You will have to modify dfun.m')
    disp('      and include the numerical ')
    disp('      c and M values.)')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('--------------------------------------------')
    disp('Now, we want to add to the plot the Euler')
    disp('numerical solution we found in the earlier')
    disp('''Limited Population Growth'' module.')
    disp(' ')
    disp('We repeat below the commands from that')
    disp('module for constructing an approximate')
    disp('solution using Euler''s Method, which is')
    disp('just repeated applications of:')
    disp('      rise = slope*run. ')
    disp('Here we use n=50 steps, which you can vary')
    disp('if you wish.  The initial population is 111.')
    disp(' ')
    disp('Copy the following commands and paste them as') 
    disp('a group at a MATLAB prompt, then execute them.')
    disp(' ')
    disp('     n=50;           ')
    disp('     Delta=100/n;    ')
    disp('     t=0:Delta:100; ')
    disp('     p(1)=111;       ')
    disp('     slope(1)=c*p(1)*(M-p(1));  ')
    disp('     for k=2:n+1 ')
    disp('        p(k)=p(k-1)+slope(k-1)*Delta; ')
    disp('        slope(k)=c*p(k)*(M-p(k)); ')
    disp('     end ')
    disp('     hold on ' )
    disp('     plot(t,p,''ro'') ')
    disp('     axis([0,100,0,1000]); ')
    disp(' ')
    disp('You should get a plot of 50 population points')
    disp('vs. time superimposed on the slope field.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('--------------------------------------------')
    disp('To go on to part 5 of this module,')
    disp('type: slope5')
    disp(' ')