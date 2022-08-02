function srectoestbin(obj, varargin)
% SRECTOESTBIN is a function for preparing SingleStep with vision
% conpatible binary for flashing from the files produced when
% building an OSEK target. 

%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.1.4.1 $  $Date: 2004/03/21 22:58:23 $
  
% Check that target preferences are set up
  sdsExe    = osektgtaction('osekprivate','getsdsexe');
  sdsExe    = osektgtaction('osekprivate','todos', sdsExe{1});
  
  if isempty(regexpi(sdsExe,'visppc.exe'))
    error('Preferences are not setup for SingleStep with vision');
  end

% Determine the name of the elf file
  switch nargin
   case 1
    subsystem = bdroot;
   case 2
    subsystem = varargin{1};
   otherwise
    subsystem = varargin{1};
  end

  if subsystem == '-'
    elf = subsystem;
    modelName = 'default';
  else
    if exist(subsystem) == 2
      elf = subsystem;
      [path, modelName,EXT,VERSN] = fileparts(elf);    
    else  
      elf = getELF(obj,subsystem);
      modelName = bdroot(subsystem);
    end
  end
  
  [elfDir elfName elfExt] = fileparts(elf);
  srec = fullfile(elfDir, [elfName '.srec']);
  
  local_dir = fileparts(mfilename('fullpath'));

  cmdPath = fileparts(sdsExe{1});
  convertpath = fullfile(cmdPath, 'convert.exe');
  if ~exist(convertpath)
    error(['The SingleStep convertion utility, ' ...
	   convertpath ...
	   ' is not available' ...
	  ]);
  end

  mpc555fcpath = fullfile(cmdPath, ...
			  'Addin_Flash_Drivers', ...
			  'custom', ...
			  'MPC555', ...
			  'c1.0e', ...
			  'mpc555fc.exe' ...
			  );
  if ~exist(mpc555fcpath)
    error(['The SingleStep convertion utility, ' ...
	   mpc555fcpath ...
	   ' is not available' ...
	  ]);
  end

  
  estint = fullfile(elfDir, [elfName '.int']);
  estbin = fullfile(elfDir, [elfName '_est.bin']);

  convertCmd = [convertpath ' -s ' srec ' -a ' estint];
  disp(['Execute convert as: ' convertCmd]);
  [s,w] = system(convertCmd);
  disp(w);
  if (s ~= 0)
    error('Converting srec to est bin');
  end
  if ~exist(estint)
    error(['Failed to create ' estint]);
  end
  
  mpc555fcCmd = [mpc555fcpath ' ' estint ' ' estbin];
  disp(['Execute mpc555fc as: ' mpc555fcCmd]);
  [s,w] = system(mpc555fcCmd);
  disp(w);
  if (s ~= 0)
    error('Converting srec to est bin');
  end
  if ~exist(estbin)
    error(['Failed to create ' estbin]);
  end

  dispMsg = sprintf('\n%s %s\n', ...
		    'Created SingleStep with vision flashable binary: ', ...
		    estbin ...
		   );
  disp(dispMsg);
return

