function Tsim = getSimTime(this)
% GETSIMTIME Computes simulation horizon and time points to hit exactly.
%
% Simulation time range is determined by the start and stop time selections,
% and the time points to hit are determined by the time points of output data
% within that range.

% Author(s): P. Gahinet, Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:43:50 $

Model = this.Experiment.Model;

util = slcontrol.Utilities;
[Tstart,Tstop,Fail] = getSimInterval(util, Model);

InheritedStart = strcmp(this.SimOptions.StartTime, 'auto');
InheritedStop  = strcmp(this.SimOptions.StopTime,  'auto');

if (InheritedStart || InheritedStop) && Fail
  error('Illegal start or stop time specified in block diagram %s.', Model)
end

% Resolve start time
if InheritedStart
  % Inherited from model
  Ts = Tstart;
else
  Ts = this.SimOptions.StartTime;
end

% Resolve stop time
if InheritedStop
  % Inherited from model
  Tf = Tstop;
else
  Tf = this.SimOptions.StopTime;
end

% Edge cases
if isinf(Tf) || Ts>=Tf
  % Always return finite Stop time
  Tf = 2*Ts + 10*(Ts==0);
end
  
% Loop over outputs
ExpOut = this.Experiment.OutputData;
Th = []; % Time points to hit exactly
for ct = 1:length(ExpOut)
  Th = [Th; ExpOut(ct).Time];
end

% Form time vector for SIM
Tsim = [Ts ; unique( Th(Th>Ts & Th<Tf) ) ; Tf];
