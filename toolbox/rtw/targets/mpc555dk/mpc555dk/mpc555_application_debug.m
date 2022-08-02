%  MPC555_APPLICATION_DEBUG
%
%  Invoke the toolchain debugger. This is intended to be
%  called from the MATLAB start menu and not the command
%  line.
%
%  Arguments
%     type  -  'ram' | 'flash'
%     file  -  [ Optional ] elf file to debug. If this
%              argument is not specified then a file
%              selector dialog will be raised. If the
%              option is an empty string then the debugger
%              will be launched without a file. This is
%              usefull for just inspecting the hardware.

%  Copyright 2003 The MathWorks, Inc.  
%  $Revision: 1.1.6.2 $
%  $Date: 2003/12/11 03:49:50 $ 
function mpc555_application_debug(type, file)

if nargin == 2
   % A specifc file is asked for
   if ~isempty(file)
      if ~exist(file,'file')
         error([file ' does not exist. ']);
      end
      if isempty(regexp(file,'\.elf'));
         error([file 'is wrong type. File must be of type *.elf']);
      end
   end
   tgtaction('run','exe',file,1);
else
   % A user interface is raised
   switch lower(type)
       case 'ram'
           filter = '*ram.elf';    
       case 'flash'
           filter = '*flash.elf';    
   end
   [filename, pathname, filterindex] = uigetfile(filter,'Select RAM applicaton file to debug');
   if isnumeric(filename) && filename == 0
       % nothing
   else
       file = fullfile(pathname,filename);
		 switch lower(type)
		 case 'ram'
			 tgtaction('run','exe',file,1,{},0);
		 case 'flash'
			 tgtaction('run','exe',file,1,{},1);
		 end
   end
end
