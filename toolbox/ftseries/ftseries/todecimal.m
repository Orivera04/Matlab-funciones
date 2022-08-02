function usddec = todecimal(usdquote, fracpart)
%TODECIMAL converts from quoted (fractional) figures to decimal equivalents.
%
%   USDDEC = TODECIMAL(USDQUOTE, FRACPART) returns the decimal equivalent,
%   USDDEC, of the quoted figure in the paper, USDQUOTE, based on the 
%   fractional base (denominator), FRACPART.
%
%   In the Wall Street Journal the bond prices are quoted in fractional
%   form based on 32nd.  For example, if you see the quoted price is 
%   100:05 it means 100 5/32 which is equivalent to 100.15625.
%
%   Example:   usddec = todecimal(100.05)
%
%              usddec =
%
%                100.1563
%
%              usddec = todecimal(97.04, 16)
%
%              usddec =
%
%                97.2500
%
%   NOTE: The entry convention of using . (period) as a substitute for :
%         (colon) is adopted from MS Excel.
%
%   See also TOQUOTE.

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.8 $   $Date: 2002/01/21 12:30:01 $

%If FRACPART is not supplied, assume using 32 as the denominator.
if nargin == 1,
   fracpart = 32;
end

%Get the integer part of the figures.
whole = floor(usdquote);

%Get the fractional part of the figures and convert them to integer to
%become the numerator of the fraction.
numerator = round((usdquote-whole)*100);

%Calculate the decimal equivalent of the fractions.
decpart = numerator/fracpart;

%Combine with the integer part to create the figures' decimal equivalents.
usddec = whole + decpart;

% [EOF]