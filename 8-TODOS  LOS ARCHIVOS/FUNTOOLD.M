%FUNTOOLD Script to demonstrate FUNTOOL.
%	Usually run by clicking the demo button in FUNTOOL.
%	The demo button poses the following challenge: Can you generate the
%	function sin(x) without touching the keyboard, using just the mouse?
%	The demo does it with a reset and then nine clicks.  If you can do
%	it with fewer clicks, please send e-mail to moler@mathworks.com.
%
%	See also FUNTOOL.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.9 $  $Date: 1994/06/16 14:54:46 $

% "B" is the vector of button handles created by FUNTOOL.

% "C" is a list of abbreviations for the button codes on the control panel.

C = ['D '; 'I '; 'S '; 'Nu'; 'De'; '1/'; 'fi'; ...
     'f+'; 'f-'; 'f*'; 'f/'; 'f^'; 'x+'; 'x*'; ...
     '+ '; '- '; '* '; '/ '; '@ '; 'g '; 'sw'; ...
     'pu'; 'cy'; 'po'; 're'; 'he'; 'de'; 'cl'];

% "prog" is a "program" consisting of a string of button codes.

prog = 're f/ I + 1/ I fi I D Nu';

% Interpret the program string.

while ~isempty(prog)
   while prog(1) == ' ', prog(1) = []; end
   s = prog(1:2);
   k = find((C(:,1) == s(1)) & (C(:,2) == s(2)));
   if isempty(k) 
      error([s ' is not a FUNTOOL command.'])
   end
   figure(3)
   set(B(k),'back','white')
   eval(get(B(k),'call'))
   pause(1)
   set(B(k),'back','default')
   prog(1:2) = [];
end
