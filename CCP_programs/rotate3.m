%  rotate3.m
% Matlab file for Part 3 of the Rotation Matrices 
% module

disp('********************************************')
disp('Part 3: Three-Dimensional Rotation Matrices')
disp('********************************************')
disp('  ')    

    format short
   
    disp('Enter the symbolic matrices for 3D rotations')
    disp('about the different coordinate axes: ')
    disp(' ')
    disp('  syms theta real ')
    disp('  P = [cos(theta) -sin(theta)  0 ')
    disp('       sin(theta)  cos(theta)  0 ')
    disp('        0             0        1] ')
    disp('  Q = [1       0           0  ')
    disp('       0   cos(theta)  -sin(theta) ')
    disp('       0   sin(theta)   cos(theta)] ')
    disp('  R = [ cos(theta)    0      -sin(theta) ')
    disp('             0        1          0 ')
    disp('        sin(theta)    0      cos(theta)] ')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')

    keyboard;
    disp(' ')
       
    disp('----------------------------------------------')
    disp('Step 1:') 
    disp('Tell what features of each of the above rotation ')
    disp('matrices tell us which axis we are revolving ')
    disp('around.  Use MATLAB comments in your diary file. ')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')

    keyboard;
    disp(' ')
       
    disp('---------------------------------------------')
    disp('Step 2: ')
    disp('Enter the following to compute the matrix P30:  ')
    disp(' ')
    disp('  d2r = pi/180; ')
    disp('  P30 = subs(P,theta,30*d2r) ')
    disp(' ')
    disp('---------------------------------------------')
    disp('Compute P45, do the calculuations called for,')
    disp('and record your observations using MATLAB ')
    disp('comments in your diary file. ')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')

    keyboard;
    disp(' ')
       
    disp('--------------------------------------------')
    disp('Step 3: ')
    disp('Compute the needed matrices, do the prescribed')
    disp('calculations, and answer the questions.')
    disp('Use MATLAB computations in your diary file')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')

    keyboard;
    disp(' ')
       
    disp('-----------------------------------------------')
    disp('Step 4: ') 
    disp('Answer the questions using MATLAB comments in ')
    disp('your diary file.')   
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')

    keyboard;
    disp(' ')
       
    disp('-----------------------------------------------')
    disp('Step 5: ') 
    disp('Compute the matrix that will accomplish the ')
    disp('desired transformation. ')
    disp(' ')
    disp('To help you visualize a sample object to be ')
    disp('transformed, the following commands generate a')
    disp('plane in 3-space. ')
    disp(' ')
    disp('  syms x1 x2 ')
    disp('  f1 = 4 - 2*x1 - 2*x2 ')
    disp('  clf  % Clears figure window ')
    disp('  ezsurf(f1,[-2,2, -2,2]) ')
    disp('  view(80,20) ')
    disp(' ')
    disp(' ')
    disp('-------------------------------------------- ')
    disp('When you are ready to go on to part 4 ')
    disp('of this module, type: rotate4.')
    disp(' ')
