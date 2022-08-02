function [mnemonic, component, msg, components] = mbcGetLastError
%MBCGETLASTERROR Split the last thrown error and return its parts
%
%  [MNEMONIC, COMPONENT, MESSAGE, COMPONENTs] = MBCGETLASTERROR takes the
%  last thrown error and returns the various parts of it.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 06:48:37 $

% First get the extended last error information
err = lasterror;
% Default outputs
mnemonic = 'UnknownError';
component = '';
components = '';
% Local copy of the identifier
id = err.identifier;
% How many bits have been found
numFound = 0;
% Looping variables
endPoint = length(id);
currentPoint = length(id);
% Extract the mnemonic and component information - this loop is JIT'ed
while currentPoint >= 0
    % Test for the delimiter or implicit delimiter at beginning of string
    if currentPoint == 0 || id(currentPoint) == ':'
        if numFound == 0
            mnemonic = id(currentPoint+1:endPoint);
        else
            component = id(currentPoint+1:endPoint);
            components = id(1:currentPoint-1);
            break
        end
        % Increment the number of found bits and the next endPoint
        numFound = numFound + 1;
        endPoint = currentPoint - 1;
    end
    currentPoint = currentPoint - 1;
end

% Now need to get the second line of the message - removing the line added
% by the MATLAB dispatcher - NOTE \n is char(10)
msg = err.message;
newlines = find(msg == 10)+1;
if isempty(newlines)
    newlines = 1;
end
msg = msg(newlines:end);