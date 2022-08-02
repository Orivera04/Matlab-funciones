function outNum = base2base(inNum,inBase,outBase)
% BASE2BASE - converts a number between two numeric base systems
%
%   X = base2base(A,B,Y) transforms the number A from base-B to base-Y,
%   outputting the string X. This script will function for all bases 
%   greater than zero and all conversion numbers greater than zero.  the 
%   bases can be any integer up to 62 as that is the number of available
%   digits, shown below.
% 
%   Digits for base conversion:
%   0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz
%
%   Example: x = base2base('28',10,16)
%            x = '1C'
%
%   Input and Output classes and descriptions:
%   A - string, the input number whose base will be changed
%   B - integer, the input base.
%   Y - integer, the output base
%   X - character array
%
%   Written by James Roberts
%   2009/02/18

% Check inputs for errors
if ~ischar(inNum)
    error('Input number must be a character array');
elseif numel(inBase) > 1 ||numel(outBase) > 1
    error('Inputs must be scalars');
elseif inBase > fix(inBase) ||outBase > fix(outBase)
    error('Inputs must be integers greater than zero');
elseif inBase <= 0 || outBase <= 0
    error('Inputs bases must be integers greater than zero');
elseif inBase > 62 || outBase > 62
    error('Bases must be less than or equal to 62');
end

% Initialize variables
allChars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

% Make sure all of the characters are valid
for iA = 1:length(inNum)
    if sum(allChars == inNum(iA)) < 1
        error('Input string contains invalid characters');
    end
end

% Convert input to base-10
if inBase == 10
    inNum10 = str2double(inNum);
else
    tmpString = flipdim(inNum,2);
    inNum10 = 0;
    for iA = 1:length(tmpString);
        tmp = (find(allChars == tmpString(iA))-1)*inBase^(iA-1);
        inNum10 = inNum10 + tmp;
    end
end

% Convert base-10 number to base-N
if outBase == 10
    outNum = inNum10;
else
    tmp = inNum10;
    outNum = '';
    while tmp >= outBase
        tmpDigit = rem(tmp,outBase);
        outNum = [outNum, allChars(tmpDigit+1)];
        tmp = fix(tmp/outBase);
    end
    outNum = fliplr([outNum, allChars(tmp+1)]);
end

