function status = mpt_static_config(featureName)
%MPT_STATIC_CONFIG MPT Static configuration file
%
%   [STATUS]=MPT_STATIC_CONFIG(FEATURENAME)
%   This functions returns the static configuration of items.
%   
%   Inputs:
%            featureName : name of feature to turn on or off
%
%   Outputs:
%            status      : status of feature to be enabled or disabled  
%
%
%

%   Patrick W. Menter
%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.4.3 $  $Date: 2004/04/15 00:29:33 $
%
%


enabled = 1;
disabled = 0;
status = disabled;

switch(featureName)
    case{'ParamsOnly'}
        status = disabled;
    case {'CodeGenSource'}
        status = disabled;
    otherwise 
        status = disabled;
end

return