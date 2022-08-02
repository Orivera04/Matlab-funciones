% eusage(text)
% written by stefan.mueller@fgan.de (C) 2007 
function eusage(text)
text=sprintf('syntax error of epsTk function\nusage: %s',text);
disp('--------------------------------------------------------------------------------');
disp(text);
disp('--------------------------------------------------------------------------------');
error(' ');
