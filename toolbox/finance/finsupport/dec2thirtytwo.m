function [OutNumber, Fraction] = dec2thirtytwo(varargin)
%DEC2THIRTYTWO  Decimal quotation to thirty-second.
%   Converts N number of decimal quotation to 
%   thirty second quotation.
%
% [OutNumber, Fractions] = dec2thirtytwo(InNumber)
% 
% [OutNumber, Fractions] = dec2thirtytwo(InNumber, Accuracy)
%
% Inputs:
%   InNumber - Nx1 vector of input numbers, as decimal
%
% Optional Inputs:
%   Accuracy - Nx1 vector of accuracy desired.
%              Default is 1. Round down to nearest 
%              thirty-second integer. Other possible values 
%              are 2 (nearest half), 4 (nearest quarter) and
%              10 (nearest decile)
%              
% Outputs:
%  OutNumber - Output number, which is the InNumber rounded
%              to the closest integer, downward. 
%
%  Fractions - Fractional part in units of thirty-second and 
%              accuracy as prescribed by the input Accuracy.
%
% Example:
% InNumber = [101.78; 102.96];
% 
% [OutNumber, Fractions] = dec2thirtytwo(InNumber)

%   Author : Bob Winata
%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.3.8.2 $  $Date: 2004/04/06 01:07:08 $

if ~isnumeric(varargin{1})
    error('Input must be a numeric array. Example: ''101.56''.')
else
    InNumber = varargin{1};
end

if nargin<2 | isempty(varargin{2})
    Accuracy = 1;
else
    Accuracy = varargin{2};
    
    if any(Accuracy~=1 & Accuracy ~=2 & Accuracy ~= 4 & Accuracy ~= 10)
        error('Unsupported level of accuracy. Use 1,2,4, or 10')
    end    
end

% resize to check against 
[InNumber, Accuracy] = finargsz(1, InNumber, Accuracy);

idxAcc = Accuracy;
idxAcc(find(Accuracy == 1))  = 1;
idxAcc(find(Accuracy == 2))  = 2;
idxAcc(find(Accuracy == 4))  = 3;
idxAcc(find(Accuracy == 10)) = 4;

% table of thirty-second remainders
table = [0, 1,    nan,  nan,  nan,  nan,  nan,  nan,  nan,  nan,  nan;
         0, 0.5,    1,  nan,  nan,  nan,  nan,  nan,  nan,  nan,  nan;
         0, 0.25, 0.5, 0.75,    1,  nan,  nan,  nan,  nan,  nan,  nan;
         0, 0.1   0.2   0.3   0.4,  0.5,  0.6,  0.7,  0.8,  0.9,    1];


% the easy part: OutNumber is the digit of InNumber.
OutNumber = floor(InNumber);

% Fraction is number IN Decimal remainder of the whole.
Fraction = InNumber - floor(InNumber);

% number of quotes plus the maximum size of table due to precision request
numrow = numel(Fraction);
numcol =  size(table, 2);

% turn Fraction into matrix:
InThirtyTwo     = 32*Fraction(:, ones(numcol,1));
FracOfThirtyTwo = InThirtyTwo - floor(InThirtyTwo);

% construct a table of reference that corresponds to the 
% fractions' requested precision
tableAcc = table(idxAcc,:);

% assign result to output
[dummy idxFractionInTable] = min( [abs(FracOfThirtyTwo - tableAcc)], [], 2 );

% Finally, the output
Fraction = floor(InThirtyTwo(:,1)) +  ...
    tableAcc(sub2ind(size(tableAcc), [1:numrow]', idxFractionInTable));