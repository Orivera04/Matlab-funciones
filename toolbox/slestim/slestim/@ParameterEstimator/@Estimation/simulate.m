function SimOut = simulate(this)
% SIMULATE  Simulate the model with the estimated parameters
%
% SIMOUT A cell array of structures that contains TIME and SIGNALS fields.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:42:23 $

model      = this.Model;
SimOptions = getSettings(this.SimOptions);

% Simulate the model and abort if any errors are encountered
Simulator  = simulator.simulator( model, SimOptions, this.Experiments);
SimOut = Simulator.getCurrentResponse;

figure
for i = 1:length(SimOut)
  plot( SimOut(i).Time, SimOut(i).Data );
  if i == 1
    hold on
  end
end
hold off
