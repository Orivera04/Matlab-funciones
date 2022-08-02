function [fcns, names, ext] = getoutputfunctions(obj)
%GETOUTPUTFUNCTIONS  Return available output methods
%
%  [FCNS, NAMES, EXT] = GETOUTPUTFUNCTIONS(OBJ) returns the lsit of
%  available output functions in the object.  NAMES is a cell array
%  containing the output description for each output method.  EXT is a cell
%  array of the file extension types for each output.  The description and
%  extension information is retrieved using the 'getname' directive for
%  each output method which should return a cell array containing the
%  output extension (there should only be one for output) and the
%  description which should be suitable for putting in a file chooser
%  dialog.  For example:
%
%    {'*.blob', 'Blob files (*.blob)}
%
%  For backwards compatibility, the getname option can also return a simple
%  string which will be the description.  The extension will then be parsed
%  from this, or taken from the name of the output function if this cannot
%  be done.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.3 $  $Date: 2004/02/09 06:49:27 $

fcns = methods(obj);
ind = strcmp('cgcaloutput',fcns) | ...
    strcmp('gui_export',fcns) | ...
    strcmp('getoutputfunctions',fcns) | ...
    strcmp('getfilename',fcns) | ...
    strcmp('setfilename',fcns) | ...
    strcmp('isempty',fcns);
fcns = fcns(~ind);

if nargout>1
    names = cell(length(fcns), 2);
    for n = 1:length(fcns)
        info = feval(fcns{n},obj,'getname');
        if iscell(info)
            names(n,:) = info;
        else
            % Try to decide on an output extension, and remove ampersands
            % from description
            names{n,2} = info(info~='&');
            names{n,1} = i_getextension(info, fcns{n});
        end
    end
end


function sExt = i_getextension(sDesc, sFunc)
% Search within sDesc for ".ext" inside parentheses.
[idxStart, idxFinish] = regexp(sDesc, '\(.*\..*\)');
if ~isempty(idxStart)
    % Rip out string from within parentheses for further searching
    sSubStr = sDesc(idxStart(1)+1:idxFinish(1)-1);
    
    % Look for the first ".ext" - this handles "(.abc, .def)" examples
    [idxStart, idxFinish] = regexp(sSubStr, '\.[a-z_A-Z]*');
    sExt = ['*', sSubStr(idxStart(1):idxFinish(1))];
else
    % Use the function name
    sExt = ['*.', sFunc];
end