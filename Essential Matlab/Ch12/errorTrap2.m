stopflag = 0;
while ~stopflag
   clc;                         % Clear the screen!
   disp('Your variables are:')
   whos
   a = input...
   ('Enter Variable definition or empty to quit: ','s');
   if isempty(a),
     stopflag = 1;
   else
     try
       eval([a ';']);  % Force no output to command window!
     catch
       disp('Invalid variable assignment statement.');
       disp('The error was:');
       disp(['   ', lasterr]);
       disp('Press a key to continue');
       pause
     end
   end;
end
