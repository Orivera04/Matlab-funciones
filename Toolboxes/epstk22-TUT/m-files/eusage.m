% eusage(text)
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003 
function eusage(text)
text=sprintf('syntax error of epsTk function\nusage: %s',text);
disp('--------------------------------------------------------------------------------');
disp(text);
disp('--------------------------------------------------------------------------------');
error(' ');
