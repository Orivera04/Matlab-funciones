%  diffeqs1.m
% Matlab file for Part 1 of the Difference Equations 
% module

disp('********************************************')
disp('Part 1: Examples and Explorations')
disp('********************************************')
disp('  ')    

    format short
  
    disp('Step 1: ')
    disp('Explain why the set of all sequences of real')
    disp('numbers is a vector space.')
    disp('Use MATLAB comments in your diary file.')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')

    keyboard;
    disp(' ')
       
    disp('-----------------------------------------------')
    disp('Steps 2 and 3: ')
    disp('We must generate the values of y(k) starting ') 
    disp('from the given y0 = 20000.')
    disp('Subscripts in MATLAB must start at 1 so our')
    disp('notation will be slightly different than the ')
    disp('written module.')
    disp(' ')
    disp('Fill in your formula for y(k+1) in terms of')
    disp('y(k) below inside the ''for'' loop and enter')
    disp('the commands to generate the y values.')
    disp('  (Be sure to put a semicolon at the end of')
    disp('   the y(k+1) line to surpress unwanted output.)')
    disp('   Note that the last line outputs the final y')
    disp('   values expressed as multiples of 10000.) ')
    disp(' ')
    disp('Enter:  ')
    disp(' ')
    disp('  y0=20000;  ')
    disp(' ')
    disp('  clear y;')
    disp('  y(1)=y0; ')
    disp('  for k=1:60 ')
    disp('     y(k+1)= ?? ; % Fill formula in terms of y(k)')
    disp('  end')
    disp('  y   % Output y values for inspection ')
    disp(' ')
    disp('------------------------------------------------')
    disp('Use your result to answer the question about how')
    disp('long it will take to pay off the loan and the size')
    disp('of the last payment.')
    disp('Use MATLAB comments in your diary file.')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')

    keyboard;
    disp(' ')
       
    disp('-----------------------------------------------')
    disp('Steps 4 and 5: ')
    disp('The commands below plot the sequence y(k) as a ') 
    disp('function of the index k. ')
    disp(' ')
    disp('Enter: ')
    disp(' ')
    disp('  k=0:60;  % Can start at k=0 ')
    disp('  clf  % Clears figure window ')
    disp('  plot(k,y,''ro''); grid on ')
    disp(' ')
    disp('-----------------------------------------------')
    disp('Does the graph confirm your answer for when the')
    disp('the last payment would be made?  Also, describe')
    disp('what you learn from the shape of the graph.')
    disp('Use MATLAB comments in your diary file to answer.')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')
    
    disp('---------------------------------------------')
    disp('Step 6:')
    disp('For Example 2,we repeat the commands for')
    disp('generating and plotting a sequence, but with')
    disp('the Samuelson formula instead. ')
    disp(' ')
    disp('Enter:   ')
    disp(' ')
    disp('  a=0.9; ')
    disp('  b=0.5; ')
    disp('  y0=1; ')
    disp('  y1=1.1;  ')
    disp(' ')
    disp('  clear y;')
    disp('  y(1)=y0; ')
    disp('  y(2)=y1; ')
    disp('  for k=1:30 ')
    disp('     y(k+2)= a*(1+b)*y(k+1) - a*b*y(k) + 1; ')
    disp('  end ')
    disp('  k=0:31;   % Can start at k=0 ')
    disp('  clf  % Clears figure window ')
    disp('  plot(k,y,''ro''); grid on ')
    disp(' ')
    disp('---------------------------------------------------')
    disp('Describe what you learn from the shape of the graph.')
    disp('Use MATLAB comments in your diary file to answer.')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')
    
    disp('---------------------------------------------')
    disp('Steps 7 thru 10:')
    disp('Experiment with changing the values of the')
    disp('parameters a, b, y0, and y1 as prescribed and ')
    disp('make new plots by executing the above commands. ')
    disp(' ')
    disp('Record your descriptions and explanations as  ')
    disp('MATLAB comments in your diary file. ')
    disp(' ')
    disp(' ')
    disp('----------------------------------------------')
    disp('When you are ready to go on to part 2 ')
    disp('of this module, type: diffeqs2.')
    disp(' ')