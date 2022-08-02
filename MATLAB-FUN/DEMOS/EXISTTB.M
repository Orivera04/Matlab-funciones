function existtb
%EXISTTB Tests for the availability of individual toolboxes by name.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

global ToolboxExistenceMatrix

ToolboxExistenceMatrix=[];

% Checking for SIMULINK
ToolboxExistenceMatrix(1)=exist('simulink');

% Checking for the Signal Processing Toolbox version
% HAMMING is in all versions
if exist('hamming'),
    ToolboxExistenceMatrix(2)=2;
    % CZTDEMO is only in version 3 and above
    if exist('cztdemo'),
    	ToolboxExistenceMatrix(2)=3;
    end;
else
    ToolboxExistenceMatrix(2)=0;
end;

% Checking for the System Identification Toolbox
ToolboxExistenceMatrix(3)=exist('armax');

% Checking for the Optimization Toolbox
ToolboxExistenceMatrix(4)=exist('attgoal');

% Checking for the Neural Network Toolbox
ToolboxExistenceMatrix(5)=exist('trainbpx');

% Checking for the Control System Toolbox
ToolboxExistenceMatrix(6)=exist('rlocfind');

% Checking for the Robust Control Toolbox
ToolboxExistenceMatrix(7)=exist('aresolv');

% Checking for the Mu-Analysis Toolbox
ToolboxExistenceMatrix(8)=exist('pck');

% Checking for the Spline Toolbox
ToolboxExistenceMatrix(9)=exist('spapi');

% Checking for the Image Processing Toolbox
ToolboxExistenceMatrix(10)=exist('imhist');

% Checking for the Statistics Toolbox
ToolboxExistenceMatrix(11)=exist('anova1');


