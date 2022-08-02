%% File : getBuildType(obj,tmf)
%%
%% Abstract : 
%% 	Returns
%% 		
%% 		AE
%% 		PIL
%% 		RT
%%
%% 		depending on the name of the TMF file
%%
%% Arguments
%% 	tmf - the tmf file used in the build
%% 		

% Copyright 2002 The MathWorks, Inc.
% $Revision: 1.1 $ 
% $Date: 2002/10/02 10:15:40 $
function type = getBuildType(obj,tmf)
	% Determine whether we are in an RT AE or PIL build
	if ~isempty(regexp(tmf,'mpc555pil'))
		% PIL build
		type = 'PIL';
	elseif ~isempty(regexp(tmf,'mpc555rt'))
		% RT build
		type = 'RT';
	elseif ~isempty(regexp(tmf,'mpc555exp'))
		% AE build
		type = 'AE';
	else
		% Error
		error(['Can''t determine build type (rt | ae | pil) from tmf file <' tmf '>.']);
	end
