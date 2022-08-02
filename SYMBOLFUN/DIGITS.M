function r = digits(d)
%DIGITS Set Maple's Digits.
%	The accuracy of Maple's numeric computations is determined by Digits.
%	DIGITS, by itself, displays the current setting of Digits.
%	DIGITS(D) sets Digits to D for subsequent calculations.
%	D = DIGITS returns the current setting of Digits.
%
%	See also VPA.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.6 $  $Date: 1994/01/24 22:36:52 $

if nargin == 1
   if ~isstr(d)
      d = int2str(d);
   end
   maple(['Digits := ' d ]);
elseif nargout == 1
   r = eval(maple('Digits'));
else
   disp(' ');
   disp(['Digits = ' maple('Digits')])
   disp(' ');
end
