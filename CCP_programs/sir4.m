%  sir4.m
% Matlab file for Part 4 of the Preditor-Prey Models module
global b k

disp('********************************************')
disp('Part 4:  Relating Model Parameters to Data ')
disp('********************************************')
disp('  ')

    format short

    disp('We will keep the same initial values of ')
    disp('s, i, and r as before: ')
    s0=1
    i0=1.27e-6
    r0=0
    disp(' ')
    disp('--------------------------------------------')
    disp('For steps 1 and 2, we keep k fixed at 1/3 ')
    k=1/3
    disp(' ')
    disp('To continue, hit any key!')
    disp(' ')
    pause

    disp(' ')
    disp('--------------------------------------------')
    disp('Steps 1 and 2:  We will experiment with changing')
    disp('the parameter b to various values between 0.5')
    disp('and 2.0.  We want to see how these changes')
    disp('affect the infected population i(t). ')
    disp(' ')
    disp('First enter a value for b:')
    disp(' ')
    disp('  b= ??')
    disp(' ')
    disp('Then copy the following commands and paste them ')
    disp('as a group at a MATLAB prompt, then execute them.')
    disp(' ')
    disp('  b  ')
    disp('  [t,w]=ode23(''de3_rhs'',[0,150],[s0,i0,r0]''); ')
    disp('  plot(t,w(:,2),''r'') ')
    disp('  title(''Fraction of Population Infected, i(t)'') ')
    disp('  hold on  ')
    disp(' ')
    clf
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('--------------------------------------------')
    disp('If you want, you can clear this figure with the ')
    disp('simple command ''''clf'''' but you should ')
    disp('probably not clear the figure until you see how')
    disp('the i(t) curves change for different b values.')
    disp(' ')
    disp('Experiment with changing b and then describe ')
    disp('how these changes affect your plot.  Use MATLAB')
    disp('comments in your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('--------------------------------------------')
    disp('For steps 3-5, we keep b fixed at 1/2 ')
    b=1/2
    disp(' ')
    disp('To continue, hit any key!')
    disp(' ')
    pause

    disp(' ')
    disp('--------------------------------------------')
    disp('Steps 3-5:  We will experiment with changing')
    disp('the parameter k to various values between 0.1')
    disp('and 0.6.  We want to see how these changes')
    disp('affect the infected population i(t). ')
    disp(' ')
    disp('First enter a value for k:')
    disp(' ')
    disp('  k= ??')
    disp(' ')
    disp('--------------------------------------------')
    disp('Copy the following commands and paste them ')
    disp('as a group at a MATLAB prompt, then execute them.')
    disp(' ')
    disp('  k  ')
    disp('  [t,w]=ode23(''de3_rhs'',[0,150],[s0,i0,r0]''); ')
    disp('  plot(t,w(:,2),''r'') ')
    disp('  title(''Fraction of Population Infected, i(t)'') ')
    disp('  hold on  ')
    disp(' ')
    clf
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('------------------------------------------------')
    disp('If you want, you can clear this figure with the ')
    disp('simple command ''''clf'''' but you should ')
    disp('probably not clear the figure until you see how')
    disp('the i(t) curves change for different k values.')
    disp(' ')
    disp('Experiment with changing k and then describe ')
    disp('how these changes affect your plot.  In ')
    disp('particular, answer the question in step 5.')
    disp('Use MATLAB comments in your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('--------------------------------------------')
    disp('Steps 6 and 7:  Answer the questions posed.')
    disp('Use MATLAB comments in your diary file.')
    disp(' ')
    disp('------------------------------------------------') 
    disp('To go on to part 5 of this module,')
    disp('type: sir5')
    disp(' ')