% This script explores e and the exponential function
 
% Call a function to display a menu and get a choice
choice = eoption;
 
% Choice 4 is to exit the program
while choice ~= 4
   switch choice
       case 1
           % Explain e
           explaine;
       case 2
           % Approximate e using a limit
           limite;
       case 3
           % Approximate exp(x) and compare to exp
           x = input('Please enter a value for x: ');
           expfn(x);
   end
   % Display menu again and get user's choice
   choice = eoption;
end
