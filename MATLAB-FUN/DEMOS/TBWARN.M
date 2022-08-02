function tbwarn(toolboxName)
%TBWARN Tests for the availability of individual toolboxes by name.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if strcmp(toolboxName,'simulink'),
    fullTBName=' SIMULINK';
elseif strcmp(toolboxName,'signal'),
    fullTBName=' The Signal Processing Toolbox';
elseif strcmp(toolboxName,'sysid'),
    fullTBName=' The System Identification Toolbox';
elseif strcmp(toolboxName,'optim'),
    fullTBName=' The Optimization Toolbox';
elseif strcmp(toolboxName,'neural'),
    fullTBName=' The Neural Network Toolbox';
elseif strcmp(toolboxName,'control'),
    fullTBName=' The Control System Toolbox';
elseif strcmp(toolboxName,'robust'),
    fullTBName=' The Robust Control Toolbox';
elseif strcmp(toolboxName,'mutools'),
    fullTBName=' The Mu-Analysis Toolbox';
elseif strcmp(toolboxName,'spline'),
    fullTBName=' The Spline Toolbox';
elseif strcmp(toolboxName,'images'),
    fullTBName=' The Image Processing Toolbox';
elseif strcmp(toolboxName,'stats'),
    fullTBName=' The Statistics Toolbox';
end

str=str2mat( ...
    	' ', ...
    	[fullTBName ' is not on your path.'], ...
    	' ', ...
    	' Because of this no demos are currently available', ...
	' for this product. Use the "More Info..." button to learn', ...
	' about the product''s capabilities.');

xppage([fullTBName ' is unavailable'],str);
