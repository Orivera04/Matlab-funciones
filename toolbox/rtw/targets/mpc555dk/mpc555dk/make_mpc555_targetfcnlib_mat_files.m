function make_mpc555_target_fcnlib_mat_files()
%MAKE_MPC555_TARGET_FCNLIB_MAT_FILES is a utility to create the TFL .mat files.
%   MAKE__MPC555_TARGET_FCNLIB_MAT_FILES is a utility that creates the Target
%   Function Library files used by each supported compiler.
  
%   Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $
%   $Date: 2004/04/08 20:58:20 $

currDir = pwd;
addpath(currDir);

try
    cd(fullfile(matlabroot,'toolbox','rtw','targets','mpc555dk','mpc555dk'));

    if (~force_file_delete('diab_tfl_tmw.mat')) error('Creating file'); end
    h = make_diab_tfl;
    h.writeLib;
    disp('Created diab_tfl_tmw.mat')
    make_read_only('diab_tfl_tmw.mat');
    
    if (~force_file_delete('codewarrior_tfl_tmw.mat')) error('Creating file'); end
    h = make_codewarrior_tfl;
    h.writeLib;
    disp('Created codewarrior_tfl_tmw.mat')
    make_read_only('codewarrior_tfl_tmw.mat');
    
catch
    disp(['Error creating math library files: ' lasterr]);
    error('ERROR: cannot make one or more Target Function Library MAT files');
end

cd(currDir)
rmpath(currDir)


function ok = force_file_delete(fileName)

    if exist(fullfile(pwd,fileName))~=2
        ok = 1;
        return;
    end
    
    try
        dtxt = evalc(['delete(''' fileName ''');']);
        %delete(fileName);
        if exist(fullfile(pwd,fileName))==2, 
             error('could not delete'); 
        end
        ok = 1;
    catch
        try,
            if ispc,
                dos(['attrib -r ' fileName]);
            else
                unix(['chmod +w ' fileName]);
            end
            dtxt = evalc(['delete(''' fileName ''');']);
            %delete(fileName);
            if exist(fullfile(pwd,fileName))==2, 
              error('could not delete'); 
            end
            ok = 1;
        catch
            disp(['Could not delete ' fileName]);
            ok = 0;
        end
    end
    
function make_read_only(fileName)

    try,
        if ispc,
            dos(['attrib +r ' fileName]);
        else
            unix(['chmod -w ' fileName]);
        end
    catch,
    end
          