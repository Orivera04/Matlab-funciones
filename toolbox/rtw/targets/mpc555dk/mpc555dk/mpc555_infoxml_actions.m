% MPC555_INFOXML_ACTIONS actions performed by the info.xml file
%
% Execute
%
% mpc555_infoxml_actions('help')
%
% for a list of valid actions
%
%   


% Copyright 2002-2003 The MathWorks, Inc.
% $Revision: 1.1.6.2 $
% $Date: 2004/04/19 01:26:54 $
function mpc555_infoxml_actions(action)
fcns = which('-subfun',mfilename);
if ~ismember(action,fcns)
    error([ action  ' is not a supported action. Supported actions are { ' sprintf('%s ',fcns{:}) ' } ']);
end
feval(action);
end

%% Actions %%

% PREFSGUI
function prefsgui
p = RTW.TargetPrefs.load('mpc555.prefs');
p.gui;
end

% HELP
function help
disp('----------------------');
disp('MPC555_INFOXML_ACTIONS');
disp('----------------------');
fcns = which('-subfun',mfilename);
fprintf('%s\n',fcns{:});
disp('----------------------');
end
