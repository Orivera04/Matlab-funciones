% Prompt the user for angle and 'd' for degrees
% or 'r' for radians; print the sine of the angle
 
% Read in the response as a string and then
% separate the angle and character
degrad = input('Enter angle and d/r: ', 's');
angle = degrad(1:end-1);
dorr = degrad(end);
 
% Error-check to make sure user enters 'd' or 'r'
while dorr ~= 'd' && dorr ~= 'r'
   disp('Error! Enter d or r with the angle.')
   degrad = input('Enter angle and d/r: ', 's');
   angle = degrad(1:end-1);
   dorr = degrad(end);
end
% Convert angle to number
anglenum = str2num(angle);
fprintf('The sine of %.1f ', anglenum)
% Choose sin or sind function
if dorr == 'd'
    fprintf('degrees is %.3f.\n', sind(anglenum))
else
    fprintf('radians is %.3f.\n', sin(anglenum))
end
