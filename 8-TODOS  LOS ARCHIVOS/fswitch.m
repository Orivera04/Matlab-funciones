
% Script file fswitch.

x = ceil(10*rand);  % Generate a random integer in {1, 2, ... , 10}
switch x
   case {1,2}
      disp('Probability = 20%');
   case {3,4,5} 
      disp('Probability = 30%');
   otherwise
      disp('Probability = 50%');
end


   