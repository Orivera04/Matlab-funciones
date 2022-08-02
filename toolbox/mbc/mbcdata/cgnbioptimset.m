function options = cgnbioptimset(varargin)
%CGNBIOPTIMSET Create OPTIM OPTIONS structure.
% options = CGNBIOPTIMSET 
% options = CGNBIOPTIMSET(shadowoptions, NBIsubproblemoptions)
% shadowsoptions and NBIsubproblemoptions option structures should be set
% using optimset('fmincon') 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:56:27 $

% Print out possible values of properties.
if (nargin == 0) & (nargout == 0)
    fprintf('        ShadowOptions: An fmincon options structure \n');
    fprintf('        NBISubproblemOptions: An fmincon options structure  \n');
    fprintf('\n');
    return;
end

if (nargin ~= 2)
    error('Two fmincon options structures should be passed to NBIoptimset');
end

options.ShadowOptions = varargin{1};
options.NBISubproblemOptions = varargin{2};

