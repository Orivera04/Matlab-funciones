%% File : getELF(this, subsystem)
%%
%% Abstract : 
%%  Return the name of the executable file
%%  that would be generated by the build process. 
%%
%% Arguments :
%%  this        -   mpc555_tgtaction object
%%  subsystem   -   The full name of the subsystem that was built
%%

% Copyright 2002-2003 The MathWorks, Inc.
% $Revision: 1.7.4.2 $ 
% $Date: 2004/04/19 01:26:29 $
function elf = getELF(obj,subsystem)

modelName = bdroot(subsystem);

% Get the name of the subsystem as
% transformed to be used as the head of
% the executable name.
name = get_param(subsystem,'name');
exeName = strtok(name,sprintf('\n\t\r\\/ '));

tmf = get_param(modelName,'RTWTemplateMakeFile');
type = getBuildType(obj,tmf);
switch type
case 'AE'
	% Algorithm export cannot run
	warning('Can''t download and run an AE build');
	elf = [ exeName '_ram.elf' ];
case 'RT'
	switch(uget_param(modelName,'TARGET_MEMORY_MODEL'))
	case 'RAM'
		elf = [ exeName '_ram.elf' ];
	case 'FLASH'
        str=([ 'Cannot download and run a FLASH target via BDM. Please use the CAN Download Flash Programmer ' ...
                'which is accessible via the MATLAB START menu.']);
		disp(' ');
        disp(' ');
        errordlg(str,'Embedded Target For MPC555 Application Download Error');
        error(str);
        
        elf = [ exeName '_flash.elf' ];
	end
case 'PIL'
	elf = [ exeName '_ram.elf' ];
end

if exist(elf) ~= 2
    n = sprintf('\n');
    t = sprintf('\t');
    msg =[n 'Cannot find the executable file ' n t elf n , ...
        'Perhapps you have not built the subsystem ' n t strrep(subsystem,n,' ') n ...
        'or you have built it with the wrong target?'];

    error(msg');
end
elf = which(elf);
