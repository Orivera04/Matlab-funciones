function s = poly2str(coefs, var)
%POLY2STR Return polynomial as string.
%
%   S = POLY2STR(P) returns a string S consisting of the polynomial
%   coefficients in the vector P multiplied by powers of the variable 'x'.
%
%   S = POLY2STR(P, 's') uses 's' as the variable rather than 'x'.
%
%   Note:  Due to a bug, the output is not always formatted as one would
%   expect, and complex coefficients are not handled well.
%
%   Example: POLY2STR([1 0 2], 's') returns the string  's^2 + 2'.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-03 22:46:15 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

error(nargchk(1, 2, nargin));

if nargin == 1
   var = 'x';
end

order = length(coefs) - 1;      % Order of polynomial.
s = '';                         % Initialize output string.

for expon = order : -1 : 0

   coef = coefs(order - expon + 1);

   % There is no point in adding a zero term (except if it's the only
   % term, but we'll take care of that later).
   if coef ~= 0

      % Is it the first term?
      isfirst = isempty(s);

      % We need the coefficient only if it is different from 1 or -1 or
      % when it is the constant term.
      needcoef = ( abs(coef) ~= 1 ) | ( expon == 0 );

      % We need the variable except in the constant term.
      needvar = ( expon ~= 0 );

      % We need the exponent except in the linear terms.
      needexpon = ( expon > 1 );

      % Add sign, but we don't need a leading plus-sign.
      if isfirst
         if coef < 0
            s = [ '-' ];        % Unary minus.
         end
      else
         if coef < 0
            s = [ s ' - ' ];    % Binary minus (subtraction).
         else
            s = [ s ' + ' ];    % Binary plus (addition).
         end
      end

      % Append the coefficient if it is different from one or when it is
      % the constant term.
      if needcoef
         coefstr = sprintf('%.15g', abs(coef));
         s = [ s coefstr ];
      end

      % Append a multiplication sign if necessary.
      if needcoef & needvar
         s = [ s '*' ];
      end

      % Append variable if necessary.
      if needvar
         s = [ s var ];
      end

      % Append exponent if necessary.
      if needexpon
         exponstr = sprintf('%.0f', expon);
         s = [ s '^' exponstr ];
      end

  end

end

% Now treat the special case where the polynomial is zero.
if isempty(s)
   s = '0';
end
