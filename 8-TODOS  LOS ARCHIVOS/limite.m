function limite
% limite returns an approximate of e using a limit
% Format: limite or limite()
 
% Call a subfunction to prompt user for n
n = askforn;
fprintf('An approximation of e with n = %d is %.2f\n', ...
    n, (1 + 1/n) ^ n)
end
 
function outn = askforn
% askforn prompts the user for n
% Format askforn or askforn()
% It error-checks to make sure n is a positive integer
 
inputnum = input('Enter a positive integer for n: ');
num2 = int32(inputnum);
while num2 ~= inputnum || num2 < 0
   inputnum = input('Invalid! Enter a positive integer: ');
   num2 = int32(inputnum);
end
outn = inputnum;
end
