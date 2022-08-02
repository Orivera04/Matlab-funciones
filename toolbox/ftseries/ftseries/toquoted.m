function usdquote = toquoted(usddec, fracpart)
%TOQUOTED converts from decimal figures to fractional equivalents (quoted).
%
%   USDQUOTE = TOQUOTED(USDDEC, FRACPART) returns the fractional equivalent,
%   USDQUOTE, of the decimal figure, USDDEC, based on the fractional base 
%   (denominator), FRACPART.  This fractional format are the ones used as
%   the quoting convention in the papers.
%
%   In the Wall Street Journal the bond prices are quoted in fractional
%   form based on 32nd.  For example, if you see the quoted price is 
%   100:05 it means 100 5/32 which is equivalent to 100.15625.
%
%   Example:   usdquote = toquoted(100.15625)
%
%              usdquote =
%
%                100.0500
%
%              usdquote = toquoted(97.25, 16)
%
%              usdquote =
%
%                97.0400
%
%   NOTE: The entry convention of using . (period) as a substitute for :
%         (colon) is adopted from MS Excel.
%
%   See also TODECIMAL.

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.8 $   $Date: 2002/01/21 12:30:07 $

%If FRACPART is not supplied, assume using 32 as the denominator.
if nargin == 1
   fracpart = 32;
end

%Get the integer part of the figures.
whole = floor(usddec);

%Get the decimal part of the figures.
decpart = usddec - whole;

%Calculate the integer numerator for the fractional representations.
%Should I use FLOOR, CEIL, or ROUND here?  Does it matter with regards to
%bid/ask prices?
numerator = round(decpart * fracpart);

%Combine with the integer part to create the figures' fractional equivalents.
usdquote = whole + (numerator/100);

% [EOF]