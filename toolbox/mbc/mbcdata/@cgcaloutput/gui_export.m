function gui_export(obj)
%GUI_EXPORT Export the data contained in the object
%
%  GUI_EXPORT(OBJ) executes an export process on OBJ.  The user is shown a
%  file-chooser dialog where they choose the filename and export type.  An
%  error dialog is shown if an the export function used returns an error
%  code.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 06:49:28 $ 


if isempty(obj)
    h = msgbox('There are no initialized calibration items available for export.', 'CAGE', 'help', 'modal');
    waitfor(h);
else
    % Get the available options for export
    [fcns, info] = getoutputfunctions(obj);
    
    prefs = mbcprefs('mbc');
    FileDefaults = getpref(prefs,'PathDefaults');
    startpth = FileDefaults.cagedatafiles;
    if exist(startpth)==7
        % Ensure there is a filesep at end of path so that uiputfile start in
        % the folder with a blank filename.
        startpth = [startpth filesep];
    else
        startpth = '';
    end
    
    [Fname, Pname, TypeIdx] = uiputfile(info, 'Export Calibration Data', startpth);
    
    if TypeIdx~=0
        [nul, nul, ext] = fileparts(Fname);
        if isempty(ext)
            % Find a default extension from save description in info.
            ext = info{TypeIdx, 11};
            DotIdx = strfind(ext, '.');
            if ~isempty(DotIdx)
                Fname = [Fname, ext(DotIdx+1:end)];
            end
        end
        
        obj.filename = fullfile(Pname, Fname);
        ok = feval(fcns{TypeIdx}, obj);
        
        if ~ok
            h = errordlg('An error occured while saving the data.', 'CAGE', 'modal');
            waitfor(h);
        end
    end
end