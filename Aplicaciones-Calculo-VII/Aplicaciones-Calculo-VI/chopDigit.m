% Author: Andrew Hastings
% Email: thebpf@hotmail.com
% v.1.062804

function choppedNumber = chopDigit(toRound, decimalPlaces)

%  chopDigit chops a number off to the specified decimal place. 
%  this is useful for removeing calculation errors sometimes 
%  associated with long double arithmetic.
%
%  chopDigit(8.234567,2) works like this:		 	
%  8.234567*100 = 823.4567   --- toRound*powerOf --- powerOf = 10^2		
%  823.4567%1 = 0.4567       --- get unwanted decimal places by modulus 1. 	
%  823.4567 - 0.4567 = 823.0 --- remove unwanted decimal places.		
%  823.0 / 100 = 8.23        --- reduce in size to get desired number.	

    powerOf = 10^decimalPlaces;
    choppedNumber = toRound.*powerOf;
    remainder = mod(choppedNumber,1);
    wholeNumber = choppedNumber - remainder;
    choppedNumber = wholeNumber/powerOf;