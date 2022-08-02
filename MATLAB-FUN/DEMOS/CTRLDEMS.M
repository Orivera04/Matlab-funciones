function ctrldems
%IDDEMS	Set up Control System demos for The MATLAB Expo.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

labelList=str2mat( ...
	'Introduction', ...
	'LQG design', ...
	'Digital Controller', ...
	'Kalman Filtering');

nameList=str2mat( ...
	'ctrldemo', ...
	'boildemo', ...
	'diskdemo', ...
	'kalmdemo');

cmdlnwin(labelList,nameList);
