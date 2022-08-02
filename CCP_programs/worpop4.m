%  worpop4.m
% Matlab file for Part 4 of the World Population module

disp('********************************************')
disp('Part 4:  When is Doomsday?')
disp('********************************************')
disp('  ')    

    format short

    r=1.190456141
    k=1.103302349e-6
    disp('Check that r and k have the values you')
    disp('computed in Part 2.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('----------------------------------------------')    
    disp('Choose a guess for a Doomsday time T=?? and')
    disp('enter it into MATLAB.')
    disp(' ')
    disp('----------------------------------------------')
    disp('Then copy and enter the next group of commands')
    disp('to make a loglog plot of P versus (T-t).')
    disp(' ')
    disp('  T ')
    disp('  timeleft=T-years; ')
    disp('  plot(log(timeleft),log(pops),''o'') ')
    disp('  xlabel(''log( T-t )'')  ')
    disp('  ylabel(''log( population )'')  ')
    disp('  title(''LogLog Plot of P versus Time Left'')')
    disp('  hold on ')
    disp('  n=size(pops,2); ')
    disp('  tpt=[log(timeleft(1)),log(timeleft(n))]; ')
    disp('  ypt=[log(pops(1)),log(pops(n))]; ')
    disp('  line(tpt,ypt); ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('-------------------------------------------')
    disp('Chose a new value for Doomsday time T')
    disp('and reinter the commands above.  Continue')
    disp('this process until your plot looks linear.')
    disp(' ')
    disp('Notice that a line is drawn between the first')
    disp('and last data points to help you find the ')
    disp('best choice of T. ')
    disp(' ') 
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('The following commands will plot the model ')
    disp('function: ')
    disp('   P(t) = 1/( (r*k*(T-t)^(1/r) ')
    disp('for your final value of T. ')
    disp('The original (years,pops) data will also ')
    disp('by plotted so we can check the fit.')
    disp('   P(t) = 1/( r*k*(T-t) )^(1/r) ')
    disp(' ')
    disp('Copy the following commands and paste them as')
    disp('a group at a MATLAB prompt, then execute them.')
    disp(' ')
    disp(' t=1000:10:2000;')
    disp(' P=1./( r*k*(T-t) ).^(1/r); ')
    disp(' clf ')
    disp(' plot(t,P,''r'') ')
    disp(' hold on ')
    disp(' plot(years,pops,''o'') ')
    disp(' ')
    disp('----------------------------------------------')
    disp(' Experiment with changing the values of k and r')
    disp(' and re-executing the above commands to see if')
    disp(' can get a better fit.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Calculate your ''''predictions'''' for  ')
    disp('world population in 1990 and 1995.')
    disp(' ')
    disp('Calculate your predictions for world ')
    disp('population in 2000, 2010, and 2020.')
    disp(' ')
    disp(' ')
    disp('----------------------------------------------')
    disp('How do your predictions compare with Census ')
    disp('Bureau estimates and projections? ')
    disp('Write as MATLAB comments in your diary file.')
    disp(' ')


