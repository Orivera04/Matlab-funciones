function y=mmonoff(x)
%MMONOFF String ON/OFF to/from Logical Conversion. (MM)
% MMONOFF('on') returns logical TRUE.
% MMONOFF('off') returns logical FALSE.
% MMONOFF returns an empty matrix for other string inputs.
% MMONOFF(X) where X is logical TRUE returns the string 'on'.
% MMONOFF(X) where X is logical FALSE returns the string 'off'.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 12/14/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if ischar(x)
   x=lower(x(isletter(x)));  % make lowercase and strip nonletters
   on=strcmp(x,'on');
   off=strcmp(x,'off');
   if      on, y=on;
   elseif off, y=~off;
   else,       y=[];
   end
else
   if x(1)~=0, y='on';
   else,       y='off';
   end
end
