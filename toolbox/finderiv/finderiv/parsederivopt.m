function [ShowWarnings, ConstRate, ShowDiagnostics] = parsederivopt(options)
% PARSEDERIVOPT
%
%   This is a private function that is not meant to be called directly
%   by the user.
%

%   Author(s): M. Reyes-Kattar, 05/01/2000
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.3 $  $Date: 2002/04/14 16:38:07 $

% Sanity check on 'options'
if ~isa(options,'struct')
  error('Options must be an options structure created with DERIVSET.');
end

% Extract options information
ShowWarnings = logical(1);
if(strcmp('off', derivget(options, 'Warnings')))
    ShowWarnings = logical(0);
end

ConstRate = logical(0);
if(strcmp('on', derivget(options, 'ConstRate')))
    ConstRate = logical(1);
end

ShowDiagnostics = logical(0);
if(strcmp('on', derivget(options, 'Diagnostics')))
    ShowDiagnostics = logical(1);
end
