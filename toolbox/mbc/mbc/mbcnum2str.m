function [str] = mbcnum2str(values, width, format)
%MBCNUM2STR significantly faster version of num2str
%
%  STR = MBCNUM2STR(VALUES, WIDTH, FORMAT)
%  
% Converts the values in VALUES to a column of string values using the
% width as a maximum (defaults to 20) and with the format specifed (as
% used in sprintf, defaults to %-20.12g)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:48:59 $ 

if nargin < 2
    width = 20;
end

if nargin < 3
    format = '%-20.12g';
end

numValues = numel(values);
if numValues > 0
    str(numValues, width) = ' ';
    for i = 1:numValues
        str(i,:) = sprintf(format, values(i));
    end
else
    str = '';
end
