%  contur2.m
% Matlab file for Part 2 of the Contour Plots and
% Critical Points module

disp('**********************************************')
disp('Part 2: First- and Second-Degree Taylor ')
disp('        Approximations ')
disp('**********************************************')
disp('  ')    

    format short
    
    disp('--------------------------------------------')
    disp('Step 1: ') 
    disp('Assuming you have calculated fx and fy in  ')
    disp('Part 1, the following commands find the second')
    disp('partials (but don''t display them because ')
    disp('they take up lots of space). ')
    disp(' ')
    disp('Enter: ')
    disp(' ')
    disp('  syms x y ')
    disp('  fxx = diff(fx, x); ')
    disp('  fxy = diff(fx, y); ')
    disp('  fyy = diff(fy, y); ')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')
    
    disp('---------------------------------------------')
    disp('Step 2: ')
    disp('Fill in a point in the domain -3<x<3, -5<y<5 and ')
    disp('evaluate the partials at the point. ')
    disp(' ')
    disp('Set values and then enter: ')
    disp(' ')
    disp('  x0=?  % Enter the point ')
    disp('  y0=?   ')
    disp(' ')
    disp('  f0=subs(f1,{x,y},{x0,y0}) ')
    disp('  fx0=subs(fx,{x,y},{x0,y0}) ')
    disp('  fy0=subs(fy,{x,y},{x0,y0}) ')
    disp('  fxx0=subs(fxx,{x,y},{x0,y0}) ')
    disp('  fxy0=subs(fxy,{x,y},{x0,y0}) ')
    disp('  fyy0=subs(fyy,{x,y},{x0,y0}) ')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('------------------------------------------------')
    disp('Step 3:')
    disp('First define the first-degree Taylor approximating')
    disp('polynomial for f near the point (x0,y0). ')
    disp(' ')
    disp('Enter: ')
    disp(' ')
    disp('  syms x y ')
    disp('  L1 = f0 + fx0*(x-x0) + fy0*(y-y0) ')
    disp('  L = fcnchk(char(L1),''vectorized'') ')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('-----------------------------------------------')
    disp('Step 3 (cont.):')
    disp('The next commands plot the contour plots of')
    disp('L and f on the square ')
    disp(' [x0-delta, x0+delta]x[y0-delta, y0+delta]. ')
    disp('f is plotted in figure 1 and L in figure 2')
    disp('for comparison purposes. ')
    disp(' ')
    disp('Enter: ')
    disp(' ')
    disp('  delta=0.5 ')
    disp(' ')
    disp('  x = linspace(x0-delta,x0+delta,50); ')
    disp('  y = linspace(y0-delta,y0+delta,50); ')
    disp('  [X,Y] = meshgrid(x,y); ')
    disp('  Z = f(X,Y); ')
    disp('  W = L(X,Y); ')
    disp('  figure(1); clf ')
    disp('  contour(x,y,Z,15) ')
    disp('  title(''Contours of f(x,y)'') ')
    disp('  figure(2); clf ')
    disp('  contour(x,y,W,15) ')
    disp('  title(''Contours of L(x,y)'') ')
    disp(' ')
    disp('-----------------------------------------------')
    disp('Reduce delta through the prescribed values and ')
    disp('redo the contour plots. ')
    disp(' ')
    disp('Describe how well the L contours match the f')
    disp('contours by using MATLAB comments in your ')
    disp('diary file.')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('------------------------------------------------')
    disp('Step 4:')
    disp('Now define the 2nd-degree Taylor approximating')
    disp('polynomial for f near the point (x0,y0). ')
    disp(' ')
    disp('Enter: ')
    disp(' ')
    disp(' syms x y ')
    disp(' T1 = fxx0*(x-x0)^2; ')
    disp(' T2 = 2*fxy0*(x-x0)*(y-y0); ')
    disp(' T3 = fyy0*(y-y0)^2; ')
    disp(' Q1 = L1 + (1/2)*(T1+T2+T3) ')
    disp(' Q = fcnchk(char(Q1),''vectorized'') ')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('-----------------------------------------------')
    disp('Step 4 (cont.):')
    disp('The next commands plot the contour plots of')
    disp('Q and f on the square ')
    disp(' [x0-delta, x0+delta]x[y0-delta, y0+delta]. ')
    disp('f is plotted in figure 1 and Q in figure 2')
    disp('for comparison purposes. ')
    disp(' ')
    disp('Enter: ')
    disp(' ')
    disp('  delta=0.5 ')
    disp(' ')
    disp('  x = linspace(x0-delta,x0+delta,50); ')
    disp('  y = linspace(y0-delta,y0+delta,50); ')
    disp('  [X,Y] = meshgrid(x,y); ')
    disp('  Z = f(X,Y); ')
    disp('  W = Q(X,Y); ')
    disp('  figure(1); clf ')
    disp('  contour(x,y,Z,15) ')
    disp('  title(''Contours of f(x,y)'') ')
    disp('  figure(2); clf ')
    disp('  contour(x,y,W,15) ')
    disp('  title(''Contours of Q(x,y)'') ')
    disp(' ')
    disp('-----------------------------------------------')
    disp('Reduce delta through the prescribed values and ')
    disp('redo the contour plots. ')
    disp(' ')
    disp('Describe how well the Q contours match the f')
    disp('contours by using MATLAB comments in your ')
    disp('diary file.')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')
    
    disp('------------------------------------------------')
    disp('Step 5')
    disp('Change the point x0, y0 and repeat steps 2-4')
    disp('for the new point. ')
    disp(' ')
    disp('-------------------------------------------------')
    disp('Discuss your results by using MATLAB comments ')
    disp('in your diary file. ')
    disp(' ')
    disp(' ')
    disp('-------------------------------------------- ')
    disp('When you are ready to go on to part 3 ')
    disp('of this module, type: contur3.')
    disp(' ')