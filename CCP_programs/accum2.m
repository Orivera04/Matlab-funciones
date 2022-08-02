%  accum2.m
% Matlab file for Part 2 of the Accumulation module

disp('********************************************')
disp('Part 2:  Summations: Size Distribution of ') 
disp('         Particles. ')
disp('********************************************')
disp('  ')    

    format short

    diameters=[0.00875, 0.0125, 0.0175, 0.0250,...
    0.0350,0.0500,0.0700,0.0900,0.112,0.137,0.175,...
    0.250, 0.350, 0.440, 0.550, 0.660,0.770,0.880,...
    1.05,1.27,1.48,1.82,2.22,2.75,3.30,4.12,5.22];
    rates=[1.57e7, 5.78e6, 2.58e6,1.15e6,6.01e5,2.87e5,...
    1.39e5,8.90e4,7.02e4,4.03e4,2.57e4,9.61e3,...
    2.15e3,9.33e2,2.66e2,1.08e2,5.17e1,...
    2.80e1,1.36e1,5.82,2.88,1.25,4.80e-1,2.17e-1,1.18e-1,...
    6.27e-2,3.03e-2];
  
    disp('Steps 1-4:')
    disp('Two lists have already been entered.')
    disp('The first is called ''''diameters'''' and')
    disp('it contains the particle size values p.')
    disp('The second list is called ''''rates'''' and')
    disp('it gives the size density values dN/dp.')
    disp(' ') 
    disp('Type: diameters if you want to see the ')
    disp('p values. Likewise, you can see the other list.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Entering the following commands will make a')
    disp('scatter plot of the (diameters, rates) pairs')
    disp('in one window and a semilog plot in another.')
    disp(' ')
    disp('   plot(diameters,rates,''ro'') ')
    disp('   title(''dN/dp versus p'') ')
    disp('   xlabel(''particle diameters p'') ')
    disp('   ylabel(''size density dN/dp'')  ')
    disp('   figure(2)  ')
    disp('   semilogy(diameters,rates,''b*'') ')
    disp('   title(''SemiLog Plot: dN/dp versus p'') ')
    disp('   xlabel(''particle diameters p'')  ')
    disp('   ylabel(''size density dN/dp'') ')
    disp(' ')
    disp('----------------------------------------------')
    disp('If you want to inspect the y values for smaller')
    disp('''''windows'''' of x values and y values, you')
    disp('can insert numbers into the command:' )
    disp('     axis([xmin xmax ymin ymax])  ')
    disp('and the plot will immediately redraw.')
    disp(' ')
    disp('----------------------------------------------')
    disp('Answer the questions in steps 3 and 4.  Write')
    disp('as MATLAB comments in your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')
    
    disp('----------------------------------------------')
    disp('Step 5:  Show your calculations in your diary')
    disp('file and give your your answer as MATLAB ')
    disp('comments there.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    format long 
    disp('Steps 6 and 7:')
    disp('We need to add up all the products of the form ')
    disp('  rates(k)*run(k),  ')
    disp('     where run(k)=diameters(k+1)-diameters(k) ')
    disp('and where k runs from 1 to one less than the ')
    disp('number of data points.' )
    disp('   (The first command below finds the number n')
    disp('    of data points.)  ')
    disp(' ')
    disp('Copy the following commands and paste them at')
    disp('a MATLAB prompt, then execute them.')
    disp(' ')
    disp('  n=size(diameters,2);  ')
    disp('  total=0 ')
    disp('  for k=1:n-1 ')
    disp('    run=diameters(k+1)-diameters(k); ')
    disp('    total=total+run*rates(k);   ')
    disp('  end    ')
    disp('  total  ')
    disp(' ')
    disp('----------------------------------------------')
    disp('Answer the questions in steps 6 and 7.  Write')
    disp('as MATLAB comments in your diary file.')
    disp('Include the the calculation needed in step 7.')
    disp(' ')
    disp(' ')
    disp('----------------------------------------------')
    disp('When your description is done, to go on to')
    disp('part 3 of this module, type: accum3.')
    disp(' ')