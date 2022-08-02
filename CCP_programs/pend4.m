%  pend4.m
% Matlab file for Part 4 of The Pendulum module
global g m b L

disp('*********************************************')
disp('Part 4:  Over the Top ')
disp('*********************************************')
disp('  ')    

    format short
    g=9.807; m=1;

    disp('We continue the damping coefficient b at zero')
    disp('and make the length L = 1 throughout this part.')
    disp('We want to study how changes in the initial')
    disp('conditions theta(0)=theta0 and ')
    disp('theta''(0)=thetap0 affect the motion.')
    b=0, L=1
    disp(' ')
    disp('--------------------------------------------')
    disp('Steps 1:')
    disp('Explain why the pendulum has an unstable ')
    disp('equilibrium when theta(0)=pi and theta''(0)=0. ')
    disp('Use MATLAB comments in your diary file.')
    disp(' ')
    disp('To continue afterwards, type the word return')
    disp('and hit enter!')
    disp(' ')

    keyboard;
    disp(' ')

    disp('----------------------------------------------')
    disp('Step 2: ')
    disp('We have copied the commands from Part 2 below.')
    disp(' ')
    disp('Find values of theta0 and thetap0 that make ')
    disp('the pendulum go over the top. ')
    disp(' ')
    disp('First enter: ')
    disp(' ')
    disp('  theta0 = 3   % change to desired ')
    disp('  thetap0 = 0.4  % ditto ')
    disp('  z0=[theta0;thetap0]; ')
    disp('  [t,z]=ode45(''de_rhs'',[0,10],z0); ')
    disp('  theta1=z(:,1); thetap1=z(:,2);  ')
    disp('  figure(1); clf  % Clears figure')   
    disp('  plot(t,theta1,''k''); grid on ')
    disp('  figure(2); clf ')
    disp('  dirfield(-10,10, -7,7); hold on ')
    disp('  comet(theta1,thetap1)  ')
    disp(' ')
    disp('----------------------------------------------')
    disp('Experiment by changing to different values of')
    disp('theta0 and thetap0 and replotting. ')
    disp(' (You may have to adjust your window sizes to ')
    disp('  get good plots.) ')
    disp(' ')
    disp('----------------------------------------------')
    disp('When your answers are done, to go on to')
    disp('part 5 of this module, type: pend5')
    disp(' ')