function hOutport = logSetup(this, system, suffix)
% Initializes data logging and return port handles

% Author(s): P. Gahinet, Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/03/10 21:55:09 $

% Default system/subsystem name
if nargin < 2
  system = this.Experiment.Model;
end

% Default data logging object name suffix
if nargin < 3
  suffix = '';
end

% Activate data logging port for this signal
OutputData = this.Experiment.OutputData;
ndata    = length(OutputData);
hOutport = zeros(ndata,1);

for ct = 1:ndata
  S = OutputData(ct);
  Block = regexprep(S.Block, this.Experiment.Model, system, 'once');

  % Associate log name
  LogName = sprintf('log%d%s', ct, suffix);
  
  % Enable data logging
  if strcmp( S.PortType, 'Signal' )
    % Log data at the output of the block
    LogPortHandles = get_param(Block, 'PortHandles');
    PortNumber = S.PortNumber;
  elseif strcmp( S.PortType, 'Outport' )
    % Log data at the output of the connecting block
    LogPortConnectivity = get_param(Block, 'PortConnectivity');
    SrcBlock = LogPortConnectivity.SrcBlock;
    LogPortHandles = get_param(SrcBlock, 'PortHandles');
    PortNumber = LogPortConnectivity.SrcPort + 1;
  end
  
  hOutport(ct) = LogPortHandles.Outport( PortNumber );
  
  set( hOutport(ct), ...
       'DataLoggingName',      LogName, ...
       'DataLoggingNameMode', 'custom' );
end
