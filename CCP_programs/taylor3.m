%  taylor3.m
% Matlab file for Part 3 of the Taylor Polynomial I module

disp('********************************************')
disp('Part 3:   Polynomial Approximations to sin(x) ')
disp('********************************************')
disp('  ')    

    format short

    disp('Step 1 and 2:')
    disp('Give the answers to the questions as MATLAB')
    disp('comments in your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')
    
    disp('--------------------------------------------')
    disp('Step 3:')
    disp('Enter the first six Tayor coefficients')
    disp('for the function sin(x) into MATLAB.')
    disp(' ')
    disp('  a0=? ')
    disp('  a1=? ')
    disp('  a2=? ')
    disp('  a3=? ')
    disp('  a4=? ')
    disp('  a5=? ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')
    
    disp('--------------------------------------------')
    disp('Step 4: First p1(x). ')
    disp('Since p0(x)=0, there''s not much point in')
    disp('plotting p0.')
    disp(' ')
    disp('The following commands plot p1(x)=a1*x + a0 along ')
    disp('with sin(x) in one figure window and the error')
    disp('function sin(x)-p0(x) in another.')
    disp(' ')
    disp('Enter these commands: ')
    disp(' ')
    disp(' c=[a1 a0]; ')
    disp(' x=-3:0.1:3; ')
    disp(' y=polyval(c,x); ')
    disp(' figure(1) ')
    disp(' plot(x,y,x,sin(x)) ')
    disp(' xlabel(''x'') ')
    disp(' ylabel(''y=p1(x)'') ')
    disp(' legend(''p1(x)'',''sin(x)'') ')
    disp(' figure(2) ')
    disp(' plot(x,sin(x)-y) ')
    disp(' xlabel(''x'') ')
    disp(' ylabel(''y = sin(x)-p1(x)'') ')
    disp(' ')
    disp('------------------------------------------- ')
    disp('Describe how well p1(x) approximates exp(x). ')
    disp('Write your description as MATLAB comments in')
    disp('your diary file. ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')
    
    disp('--------------------------------------------')
    disp('Step 4: Now p3(x). ')
    disp('Since p2(x)=p1(x) because a2=0, there''s not')
    disp('much point in plotting p2.')
    disp(' ')
    disp('The following commands plot ')
    disp('      p3(x)=a3*x^3 + a2*x^2 + a1*x + a0 ')
    disp('along with sin(x) in one figure window and the')
    disp('error function sin(x)-p3(x) in another.')
    disp(' ')
    disp('Enter these commands: ')
    disp(' ')
    disp(' c=[a3 a2 a1 a0]; ')
    disp(' x=-2:0.1:2; ')
    disp(' y=polyval(c,x); ')
    disp(' figure(1) ')
    disp(' plot(x,y,x,sin(x)) ')
    disp(' xlabel(''x'') ')
    disp(' ylabel(''y=p3(x)'') ')
    disp(' legend(''p3(x)'',''sin(x)'') ')
    disp(' figure(2) ')
    disp(' plot(x,sin(x)-y)')
    disp(' xlabel(''x'') ')
    disp(' ylabel(''y = sin(x)-p3(x)'') ')
    disp(' ')
    disp('------------------------------------------- ')
    disp('Describe how well p1(x) approximates exp(x). ')
    disp('Write your description as MATLAB comments in')
    disp('your diary file. ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')
    
    disp('--------------------------------------------')
    disp('Step 4: Continue ')
    disp('Note that each even polynomial p2(x), p4(x),')
    disp('or p6(x) is the same as the previous odd poly.')
    disp('No point in plotting them twice.')
    disp(' ')
    disp(' For the polynomial p5(x), ')
    disp(' plot p5(x) and sin(x) together and also ')
    disp(' plot the error function sin(x)-p5(x).')
    disp(' ')
    disp('Describe how well p5(x) approximates sin(x). ')
    disp('Write your description as MATLAB comments in')
    disp('your diary file. ')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')
    
    disp('--------------------------------------------')
    disp('Step 5:')
    disp('Show the MATLAB calculations needed to find ')
    disp('sin(1) to within 0.01, or use a calculator.')
    disp('Explain your reasoning as MATLAB comments')
    disp('in your diary file.')
    disp(' ')
    disp('----------------------------------------------')
    disp('When you are finished with part 3, to go on to')
    disp('part 4 of this module, type: taylor4.')
    disp(' ')