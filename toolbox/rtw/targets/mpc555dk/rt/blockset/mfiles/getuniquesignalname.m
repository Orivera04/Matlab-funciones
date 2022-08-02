function signalName = getuniquesignalname(hThisPort, baseName)
%GETUNIQUESIGNALNAME  Helper M-Function for Simulation pass through blocks.
%
%   Syntax: signalName = getuniquesignalname(hThisPort, baseName)

%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.9.4.1 $
%   $Date: 2004/04/19 01:29:38 $

if nargin~=2
  error('Invalid number of input arguments.');
end

% Check for valid input arguments
if ((isnumeric(hThisPort)) & ...
    (strcmp(get_param(hThisPort, 'Type'), 'port')))
  % Get the model handle (signal names must be unique within the model).
  hThisModel = bdroot(hThisPort);
  
  % Create a separate persistent variable for each baseName
  if iscvar(baseName)
    eval(['persistent ', baseName]);
  else
    error('Second input argument must be a valid C variable.')
  end

  hPorts = eval(baseName);
  if isempty(hPorts)
    % New baseName - create new matrix
    hPorts = [hThisModel, hThisPort];
    signalNo = 1;
  else
    % Existing baseName - find the ports in this model
    hPortsThisModel = hPorts((hPorts(:,1)==hThisModel),:);
    if isempty(hPortsThisModel)
      % First port in this model - append it to hPorts
      hPorts = [hPorts; hThisModel, hThisPort];
      signalNo = 1;
    else
      % Ports exist for this model - find the index to this port
      signalNo = find(hPortsThisModel(:,2)==hThisPort);
      if isempty(signalNo)
        % Index not available for this port - append it to hPorts
        hPorts = [hPorts; hThisModel, hThisPort];
        signalNo = size(hPortsThisModel, 1)+1;
      end
    end
  end
  % Store hPorts in the persistent variable (NOTE: may not have been changed).
  eval([baseName, ' = hPorts;']);
else
  error('First input argument must be a port handle.');
end

% Construct signal name from baseName and signalNo
signalName = [baseName, num2str(signalNo)];