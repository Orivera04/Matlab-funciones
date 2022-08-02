%  limpop5.m
% Matlab file for Part 5 of the Limited Population module

disp('*********************************************')
disp('Part 5:  Fruit Flies:  Increasing the Number')
disp('  of Steps');
disp('*********************************************')
disp('  ')    

    disp('We have copied all the relevant MATLAB')
    disp('commands so that you can easily copy and')
    disp('execute them.')
    disp(' ')
    disp('We want to change the number of steps to n=40.')
    disp('First assign n=40.')
    disp(' ')
    disp('----------------------------------------------')
    disp('Now, with n assigned, copy the following') 
    disp('commands and paste them as a group at a MATLAB')
    disp('prompt and then execute them.')
    disp(' ')
    disp('     Delta=100/n;    ')
    disp('     for k=1:n+1 ')
    disp('        t(k)=(k-1)*Delta; ')
    disp('     end ');
    disp('     for k=2:n+1 ')
    disp('        p(k)=p(k-1)+slope(k-1)*Delta; ')
    disp('        slope(k)=c*p(k)*(M-p(k)); ')
    disp('     end ')
    disp('     figure(1) ')
    disp('     plot(t,p,''o'') ')
    disp(' ')
    disp('You should get a plot of 40 population points')
    disp('vs. time.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('--------------------------------------------')  
    disp('You can plot the slope points versus time in')
    disp('a similar manner.')
    disp(' ')
    disp('Copy and execute the following commands.')
    disp(' ')
    disp('     figure(2)  ')
    disp('     plot(t,slope,''r+'') ')
    disp(' ')
    disp('You should get a plot of 40 slope points')
    disp('vs. time.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('--------------------------------------------')
    disp('We need to save the sets of 40 t points,')
    disp('40 p points, and 40 slope points we just')
    disp('generated for later.')
    disp('  ')
    disp('Copy the following commands and paste them as')
    disp('a group at a MATLAB prompt, then execute them.')
    disp(' ')
    disp('     t40=t;      ')
    disp('     p40=p;      ')
    disp('     slope40=slope;   ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('------------------------------------------------------')
    disp('Now we want to make population and slope')
    disp('curve plots for n=80, 160, and 320 steps.')
    disp('  ')
    disp('First assign the desired value to n.')
    disp('  ')
    disp('Then all you have to do is copy the commands')
    disp('we used above.')
    disp('  ')
    disp('Be sure to save the points as t80, p80,')
    disp('slope80, etc. after you generate each set.')
    disp('  ')
    disp('To continue after you have generated all the')
    disp('plots, type the word return and hit enter!')
    disp(' ')

    keyboard; 
    disp(' ')

    disp('-----------------------------------------------')
    disp('To make a plot comparing the population curve')
    disp('for 20 steps versus the one for 80 steps,') 
    disp('copy and execute the following plot commands.')
    disp('  ')
    disp('   figure(1) ')
    disp('   plot(t20,p20,''o'',t80,p80,''+'') ')
    disp('  ')
    disp('You should likewise make a comparison plot')
    disp('of slope points.')
    disp('  ')
    disp('To continue afterwards type the word return')
    disp('and hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Make more comparison plots to see how')
    disp('increasing the number of steps affects the')
    disp('population and slope curves.')
    disp('  ')   
    disp('Record your observations as comments in your')
    disp('diary file about the population and slope')
    disp('curves with 40, 80, 160, and 320 time steps')
    disp('  ')
    disp('----------------------------------------------')
    disp('To go on to part 6 of this module,')
    disp('type: limpop6')
    disp(' ')
   
 
  