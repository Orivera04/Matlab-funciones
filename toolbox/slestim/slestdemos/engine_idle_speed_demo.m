% ENGINE_IDLE_SPEED_DEMO
%
% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/01/03 12:25:19 $

%% Open the model and load experimental data.
open_system('engine_idle_speed')

%% Create objects to represent the experimental data sets.
hExp = ParameterEstimator.TransientExperiment(gcs);
set(hExp.InputData(1),  'Data', iodata(:,1), 'Time', time);
set(hExp.OutputData(1), 'Data', iodata(:,2), 'Time', time);

%% Create objects to represent parameters and set initial model states.
hPar(1) = ParameterEstimator.Parameter('gain1', 'Minimum', 100);
hPar(2) = ParameterEstimator.Parameter('gain2', 'Minimum', 0);
hPar(3) = ParameterEstimator.Parameter('gain3', 'Minimum', 0);
hPar(4) = ParameterEstimator.Parameter('mean_speed', 'Minimum', 600);
set(hPar, 'Estimated', true)

%% Create the estimation object
hEst = ParameterEstimator.Estimation(gcs, hPar, hExp);

%% Setup estimation options
hEst.OptimOptions.Algorithm    = 'fmincon';
hEst.OptimOptions.RobustCost   = 'off';
hEst.OptimOptions.GradientType = 'basic';
hEst.OptimOptions.Display      = 'iter';

%% Compare simulation vs. experiment before estimation
compare(hEst, hExp);

%% Run the estimation
estimate(hEst);

%% Look at the estimated values
find(hEst.Parameters, 'Estimated', true)

%% Compare simulation vs. experiment after estimation
compare(hEst, hExp);
