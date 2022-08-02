%  equi3.m
% Matlab file for Part 3 of The Equiangular Spiral 
% module

disp('**********************************************')
disp('Part 3: Plotting a Spiral Curve ')
disp('**********************************************')
disp('  ')    

    format short

    disp('Step 1: ') 
    disp('Use the relation: theta = (pi/4)*t  ')
    disp('to construct the function r(theta).')
    disp(' ')
    disp('Give your results using MATLAB comments in')
    disp('your diary file.')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')
    
    disp('---------------------------------------------')
    disp('Step 2: ')
    disp('Fill in your formula r(theta) below and then ')
    disp('make the polar plot for the theta values ')
    disp('between -2*pi and 4.5*pi. ')
    disp('  (The ''''linspace'''' command below generates')
    disp('   1000 equally spaced theta values.) ')
    disp('Enter: ')
    disp(' ')
    disp('  theta = linspace(-2*pi,4.5*pi,1000); ')
    disp('  r= ???;  % Fill in function of theta. ')
    disp('  figure(1); clf ')
    disp('  polar(theta, r, ''b'') ')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')
    
    disp('---------------------------------------------')
    disp('Step 3: ')
    disp('Fill in formulas to calculate x and y in terms')
    disp('of the r and theta values you have calculated')
    disp('above and then graph a connected curve of ')
    disp('(x,y) pairs.')
    disp('  ')
    disp('Enter: ')
    disp(' ')
    disp('  x=???;  % use formula in r and theta ')
    disp('  y= ???;   ')
    disp('  figure(2); clf ')
    disp('  plot(x, y, ''r''); axis equal ')
    disp(' ')
    disp('---------------------------------------------')
    disp('Do you get the same curve as in step 2?')
    disp(' ')
    disp('Summmarize your results using MATLAB comments')
    disp('in your diary file.')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')
    
    disp('---------------------------------------------')
    disp('Step 4: ')
    disp('Modify the commands in step 2 and replot ')
    disp('the polar curve for the new theta interval ')
    disp('-10*pi to 4.5*pi. ')
    disp('   (Note: To multiply the terms of one matrix')
    disp('    times the corresponding terms of the same')
    disp('    size matrix, you need to use the ''.*'' ')
    disp('    operator, not ''*'' alone.) ')
    disp(' ')
    disp('---------------------------------------------')
    disp('Use MATLAB comments in your diary file to ')
    disp('describe how the plot is changed. ')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')
    
    disp('---------------------------------------------')
    disp('Step 5 and 6: ')
    disp('You can zoom in on the graph by simply ')
    disp('entering ''''zoom'''' and then clicking on')
    disp('the figure window at the center of the portion')
    disp('you want to enlarge.  You can click repeatedly.')
    disp('Type ''''zoom out'''' to return to original.')
    disp(' ')
    disp('---------------------------------------------')
    disp('Use MATLAB comments in your diary file to ')
    disp('explain what you see. How is the behavior')
    disp('different than what you usually see when you ')
    disp('zoom in on a continuous curve?')
    disp(' ')
    disp('-------------------------------------------- ')
    disp('When you are ready to go on to part 4 ')
    disp('of this module, type: equi4.')
    disp(' ')