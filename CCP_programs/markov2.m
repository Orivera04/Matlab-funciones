%  markov2.m

% Matlab file to accompany Part 2 of the Markov
% Chain module.

% Part 2:  Rental Cars

disp('  ')
disp('Part 2:  Rental Cars')
disp('  ')

  % Enter the matrix M and the vector p0 (car initially at location 2)
  format short
  
    M = [ 0.8 0.3 0.2; 0.1 0.2 0.6; 0.1 0.5 0.2];
    p0 = [0; 1; 0];
    
    disp('Type M to see the transition matrix.')
    disp('Type p0 to see the initial vector.')
    disp('  ')
    disp('When you are ready to go on to Part 3, ')
    disp('type markov3.')
    disp('  ')
