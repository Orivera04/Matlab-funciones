function OutNumber = thirtytwo2dec(InNumber, InFraction)
%THIRTYTWO2DEC Thirty-second quotation to decimal.
%   The function computes N number of decimal value
%   as the sum of input whole number and thirty second
%   quotation.
%
% OutNumber = thirtytwo2dec(InNumber, InFraction)
%
% Inputs:
%   InNumber - Nx1 vector of integer input number, 
%              representing price without the fractional 
%              components.
%              Example: 101
%               
% InFraction - Nx1 vector of input fraction number 
%              associated with each element in InNumber.
%              Example: 31.5
%
% Outputs:
%  OutNumber - Sum of InNumber and InFraction, in decimal.
%
% Example:
% InNumber   = [101;102;103];
% InFraction = 25;
% 
% OutNumber = thirtytwo2dec(InNumber, InFraction)

%   Author : Bob Winata
%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.3.8.2 $  $Date: 2004/04/06 01:07:10 $
if nargin<2
    error('Not enough input arguments.')
else
    % resizing input arguments so they conform
    [InNumber, InFraction] = finargsz(1, InNumber, InFraction);
    
    % inadmissible result due to bad data
    if any(InFraction >= 32)
        error('A fraction greater than or equal tot 32/32 detected.')
    end
    
    OutNumber = InNumber + InFraction/32;
end