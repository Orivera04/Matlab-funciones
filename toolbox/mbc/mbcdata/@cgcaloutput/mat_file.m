function ret = mat_file(obj,opt)
%MAT_FILE  Export to mat-file format
%
%  RET = MAT_FILE(OBJ) exports the output object to a Matlab mat-file that
%  can be loaded back into Matlab's workspace.  RET will be true if the
%  file was successfully written, false otherwise.
%
%  INFO = MAT_FILE(OBJ, 'getname') returns a cell array containing the
%  information required for building a list of available output formats. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.2.3 $  $Date: 2004/02/09 06:49:31 $

if nargin>1 && strcmp(opt,'getname')
    ret = {'*.mat', 'MATLAB File (*.mat)'};
else
    if ~isempty(obj.filename)
        savedata = struct;
        if ~isempty(obj.ptrlist)
            data = pveceval(obj.ptrlist, @getcharacteristic);
            for n = 1:length(data)
                savedata.(data{n}.name) = data{n};
            end
        end
        try
            save(obj.filename, '-struct', 'savedata', '-mat');
            ret = true;
        catch
            ret = false;
        end
    else
        ret = false;
    end
end