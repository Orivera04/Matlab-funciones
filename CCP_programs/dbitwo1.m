%  dbitwo2.m
% Matlab file for Part 2 of The Double Integrals II 
% module

disp('**********************************************')
disp('Part 2:  Balloons at the Fair ')
disp('**********************************************')
disp('  ')    

    format short
    
    disp('--------------------------------------------')
    disp('Step 1: ')     
    disp('We use MATLAB''s symbolic capabilities to ')
    disp('evaluate the iterated integral: ')
    disp(' ')
    disp(' syms x y  ')
    disp(' f = x*y^2 + x - y ')
    disp(' exact = int( int(f,y,x^2,sqrt(x)), x, 0,1); ')
    disp(' exact ')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')
    
    disp('---------------------------------------------')
    disp('Step 2: ')
    disp('The following will sometimes work.  Change')
    disp('the last command above to: ')
    disp(' ')
    disp('  val=double(exact)')
    disp(' ')
    disp('---------------------------------------------')
    disp('For particularly complicated integrands, this')
    disp('method may not work.  For some integrals, however,')
    disp('you will get a numerical answer even though you ')
    disp('cannot get a closed form symbolic answer.')
    disp(' ') 
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')

    disp('---------------------------------------------')
    disp('Step 2 (cont.): ')
    disp('An alternative method can be used used when the: ')
    disp('inner integral has a symbolic expression: ')
    disp(' ')
    disp(' inner = int(f,y,x^2,sqrt(x)) ')
    disp(' % convert to inline function')
    disp(' finner = fcnchk(char(inner),''vectorized'') ')
    disp(' % integrate with numerical integrator')
    disp(' val = quad8(finner,0,1) ')
    disp(' ')
    disp('To continue, type the word return and ')
    disp('hit enter!')
    disp(' ')
    
    keyboard;
    disp(' ')
    
    disp('------------------------------------------------')
    disp('Step 3 thru 5')
    disp('Express the double integral in polar coordinates.')
    disp(' ')
    disp('Use ''''syms r theta'''' to define symbolic ')
    disp('variables and then set up the double integral and')
    disp('let MATLAB evaluate it exactly. ')
    disp('     (The inner integral will be with')
    disp('      respect to r and the limits will ')
    disp('      be functions of theta.) ')
    disp(' ')
    disp(' ')
    disp('-------------------------------------------- ')
    disp('When you are ready to go on to part 2 ')
    disp('of this module, type: dbitwo2.')
    disp(' ')
