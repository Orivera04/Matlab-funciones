%  markov1.m

% Matlab file for Part 1 of the Markov Chains module

% Part 1:  Television Viewers
disp('  ')
disp('Part 1:  Television Viewers');    
    
    disp('  ')
    disp('Enter as a comment -- to be saved')
    disp('in your diary file -- your guess')
    disp('about the long-run distribution.')
    disp('  ')
  % Enter the matrix A and the vector p0
  format short
  
    A = [ 0.85 0.05; 0.15 0.95 ];
    p0 = [0.4; 0.6];
    
    disp('Type p0 to see the starting vector.')
    disp('Type A to see the transition matrix.')
    disp(' ')
    disp('When you are ready to go on')
    disp('to Part 2, type markov2.')
    disp('  ')
    
    
