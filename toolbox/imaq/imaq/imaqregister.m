function out = imaqregister(adaptor, action)
%IMAQREGISTER Register third party Image Acquisition Toolbox adaptors.
%
%   ADAPTORS = IMAQREGISTER returns an N-by-1 cell array of text strings
%   where each string is the full path of a registered third party
%   adaptor.  If there are no registered third party adaptors,
%   IMAQREGISTER returns an empty cell array.
%
%   ADAPTORS = IMAQREGISTER(ADAPTORPATH) registers the third party adaptor
%   library specified by ADAPTORPATH.  ADAPTORPATH must be a 1-by-N character
%   array specifying the full absolute path to the adaptor library file.
%   The list of registered adaptors is returned after the specified
%   adaptor has been registered.
%
%   Registering an adaptor informs the Image Acquisition Toolbox of the
%   location of a third party adaptor library.  If IMAQHWINFO is used to
%   query the system for available image acquisition hardware, the toolbox
%   will make available any adaptor libraries that have been registered.  
%
%   The IMAQREGISTER function saves the name of the registered adaptor in
%   the MATLAB preferences directory so that the location persists across
%   MATLAB sessions.  Because IMAQHWINFO caches the list of available
%   adaptors, it may be necessary to call IMAQRESET after calling
%   IMAQREGISTER for the registered adaptor to be available.
%
%   The IMAQHWINFO and VIDEOINPUT functions use the adaptor base name, not
%   the full path.  For example, if the adaptor name is "c:\adaptor.dll",
%   the adaptor base name is "adaptor".
%
%   ADAPTORS = IMAQREGISTER(ADAPTORPATH, ACTION) where ACTION is either
%   'register' or 'unregister' performs the action specified by ACTION. If
%   ACTION is 'register', the third party adaptor is registered as
%   described above.  If ACTION is 'unregister', the third party adaptor
%   will be removed from the list of available adaptors. The default value
%   of ACTION is 'register'.  ADAPTORS indicates the list of registered
%   adaptors after ADAPTORPATH has been unregistered.
%
%   Example:
%      % Register a third party library.
%      imaqregister('c:\temp\thirdpartyadaptor.dll');
%
%      % Create a videoinput object with the registered adaptor.
%      videoinput('thirdpartyadaptor', 1);
%
%  See also IMAQHWINFO, VIDEOINPUT, IMAQRESET.

% DT 11/2003
% Copyright 2001-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/02/01 21:46:12 $

if (nargin == 1)
    % If the user has not specified the action, it should default to
    % 'register'.
    action = 'register';
elseif (nargin == 2)
    
    % The user has specified the action.  First make sure that it is a
    % character vector.
    if ( ~(isvector(action) && ischar(action)) )
        eid = 'imaq:imaqregister:invalidaction';
        error(eid, privateMsgLookup(eid));
    end
    
    % Next verify that the action is either 'register' or 'unregister'.
    if ( ~(strcmpi(action, 'register') || strcmpi(action, 'unregister')) )
        eid = 'imaq:imaqregister:invalidaction';
        error(eid, privateMsgLookup(eid));
    end
end

if (nargin > 0);
    
    % Verify that adaptor is a vector of characters.
    if ( ~(isvector(adaptor) && ischar(adaptor)) )
        eid = 'imaq:imaqregister:invalidadaptorpath';
        error(eid, privateMsgLookup(eid));
    end
    
    % Attempt to perform the action.  if the action fails, catch the error
    % and rethrow it so that the user does not see the backtrace.
    try
        switch lower(action)
            case 'register'
                localRegisterAdaptor(adaptor);
            case 'unregister'
                localUnregisterAdaptor(adaptor);
        end
    catch
        rethrow(lasterror)
    end
end

% Return the current list of registered adaptors.
out = privateGetSetUserPrefAdaptors;

% Make sure that out is a column vector.
out = out(:);

function localRegisterAdaptor(adaptorFile)
% Registers an adaptor.  adaptorFile should be a 1xN character array.

% Make sure that the file exists.
if ~exist(adaptorFile, 'file')
    eid = 'imaq:imaqregister:filenotfound';
    error(eid, sprintf(privateMsgLookup(eid), strrep(adaptorFile, '\', '\\')));
end

% Verify that the user specified an absolute path name to the object.
[adaptorPath, adaptorName] = fileparts(adaptorFile);

if ( isempty(adaptorPath) || strcmp(adaptorPath(1), '.') )
    eid = 'imaq:imaqregister:nonfullpath';
    error(eid, privateMsgLookup(eid));
end

% For the PC, verify that either the drive is specified or a UNC path
% is specified.
if ispc
    if ( ~(strcmp(adaptorPath(2), ':') || strcmp(adaptorPath(1:2), '\\')) )
        eid = 'imaq:imaqregister:nonfullpath';
        error(eid, privateMsgLookup(eid));
    end
end

% Get the list of currently registered adaptors.
[fullAdaptorPath oldAdaptors] = privateAdaptorSearch;

% Loop through all of the existing adaptors to make sure that none of them
% will resolve to the same name.
if any(strcmpi(oldAdaptors, adaptorName))
    eid = 'imaq:imaqregister:alreadyregistered';
    error(eid, ...
        sprintf(privateMsgLookup(eid), adaptorName));
end

% All tests have passed, save the adaptor

% Need to get only the registered adaptors.
oldAdaptors = privateGetSetUserPrefAdaptors;
oldAdaptors = {oldAdaptors{:}; adaptorFile};

try
    privateGetSetUserPrefAdaptors(oldAdaptors);
catch
    rethrow(lasterror)
end

function localUnregisterAdaptor(adaptorFile)

% Get the list of currently registered adaptors.
oldAdaptors = privateGetSetUserPrefAdaptors;

% See if the specified adaptor is already known.
adaptorFound = strcmpi(oldAdaptors, adaptorFile);

% If the adaptor was found, remove it, otherwise error.
if any(adaptorFound)
    oldAdaptors(adaptorFound) = [];
    
    % Remove the adaptors.
    try
        privateGetSetUserPrefAdaptors(oldAdaptors(:));
    catch
        rethrow(lasterror)
    end
else
    state = warning('off', 'backtrace');
    wid = 'imaq:imaqregister:unregisterfailed';
    warning(wid, sprintf(privateMsgLookup(wid), strrep(adaptorFile, '\', '\\')));
    warning(state);
end