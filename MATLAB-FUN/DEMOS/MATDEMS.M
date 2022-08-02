function matdems
%MATDEMS For setting up matrix computation demos from the MATLAB Expo.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

labelList=str2mat( ...
	'Matrix Eigenvalues', ...
	'Row Echelon Form', ...
	'Finite differences', ...
	'Finite elements', ...
	'NASA airfoil');

nameList=str2mat( ...
	'eigmovie', ...
	'rrefmovie', ...
	'delsqdemo', ...
	'sepdemo', ...
	'airfoil');

% The figure flag list is used to indicate whether or not a figure
% window is required by the demo
figureFlagList=[
	0
	0
	1
	1
	1];

% Airfoil is too big for the Student Edition
if isstudent
   labelList(5,:) = [];
   nameList(5,:) = [];
   figureFlagList(5) = [];
end

cmdlnwin(labelList,nameList,figureFlagList);
