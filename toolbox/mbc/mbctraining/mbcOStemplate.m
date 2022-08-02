function out = mbcOStemplate(action, in)
%MBCOSTEMPLATE CAGE Optimization template function
%   OUT = MBCOSTEMPLATE(ACTION, IN) is a template function for use with
%   CAGE Optimization. This function can be used to create user-defined
%   optimization functions that can subsequently be used in CAGE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2004/02/09 08:21:20 $ 

% Deal with the action inputs
if strcmp(action, 'options')

    options = in;

    %
    % Define optimization attributes here
    %
    
    out= options;
    
elseif strcmp(action, 'evaluate')
    
    optimstore = in;
    
    %
    % Put optimization algorithm here
    %
    
    out = optimstore;
    
else
    error('Incorrect action type specified');
end
