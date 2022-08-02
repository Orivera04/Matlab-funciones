%GAprompt: repeatedly prompt for keyboard input.
%  Stop prompting on a blank line or on a GAend line.
%  Prevent calls to GAblock.
%  You can change the prompt by setting the global variable 'GAps'
%   to the desired prompt.
%  If the global variable 'GAmouse' is 1, then GAprompt will wait
%   for a button press rather than prompt for input.
%
%See also gable.

% Made this a script to allow access to global variables

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
GAn=1;
while GAn==1
 GAtmp = who('GAmouse');
 if strcmp(GAtmp,'GAmouse') & GAmouse
     fprintf(1,'.');
     waitforbuttonpress;
     return
 end
 GAtmp = who('GAps');
 if strcmp(GAtmp,'GAps')
     GAns=input(GAps,'s');
 else
     GAns=input('>>>> Enter a command or press return to continue: >> ','s');
 end
 if strcmp(GAns,'')
   GAn = 0;
 elseif strcmp(GAns,'GAend')
   error('GAend aborts a script');
 elseif ~isempty(findstr(GAns,'GAblock'))
   disp('Can''t have nested GAblock calls.');
 else
   try
     eval(GAns);
   catch
     disp(lasterr);
     disp('Invalid command.  Try again.');
   end
 end
end
