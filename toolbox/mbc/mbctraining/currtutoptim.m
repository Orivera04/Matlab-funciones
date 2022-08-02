function [bestx, OUTPUT] = currtutoptim(x0, fixedvars)
%CURRTUTOPTIM CAGE Optimization tutorial - Original Algorithm
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/04/04 03:32:51 $ 

no_of_speed_load_points = size(fixedvars, 1);

% Optimization options
algoptions = optimset('LargeScale', 'off', 'Display', 'off');

% Optimize torque
waitH = waitbar(0,'','name','Tutorial Optimization');
for i = 1:no_of_speed_load_points
    [bestx(i, :), notused1, notused2, OUTPUT(i)] = fminunc(@i_evalObj, x0, algoptions,fixedvars(i, :));
    wbarstr = ['Computing optimal settings for operating point ' num2str(i)];
    waitbar((i-1)/no_of_speed_load_points,waitH, wbarstr);    
end
    
% End Optimization
waitbar(1,waitH, 'Optimization completed');
close(waitH);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tq = i_evalObj(x0, fixedvars)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Evaluate the torque objective function

tq = trqfunc(x0(1), x0(2), fixedvars(1), fixedvars(2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = trqfunc(S, A, N, L)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TRQFUNC Objective function (Torque) for Optimization example
%

% Load the torque model from MBC
load('optimtut.mat');

% Evaluate
y = EvalModel(tq, [S, N, L, A]);
y = -y;
