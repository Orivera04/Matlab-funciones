function libpaths = privateGetSetUserPrefAdaptors(adaptorsToWrite)
%PRIVATEGETSETUSERPREFADAPTORS Get and set the registered adaptors.
%
%   ADAPTORS = PRIVATEGETSETUSERPREFADAPTORS returns the currently
%   registered adaptors as an N-by-1 cell array.
%
%   ADAPTORS = PRIVATEGETSETUSERPREFADAPTORS(ADAPTORSTOWRITE) saves the
%   specified list of adaptors to the user's preferences directory.
%   ADAPTORSTOWRITE must be a N-by-1 cell array.  ADAPTORS is the list of
%   adaptors after saving.
%
%   PRIVATEGETSETUSERPREFADAPTORS is used internally by the toolbox.  It is
%   not intended to be used directly by an end user.
%
%   See also PRIVATEADAPTORSEARCH.

% DT 11/2003
% Copyright 2001-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/02/01 21:46:28 $

error(javachk('jvm', 'IMAQREGISTER'));

switch nargin
    case 0
        adaptors = char(com.mathworks.services.Prefs.getStringPref('imaqadaptors'));
        libpaths = strread(adaptors, '%s', 'delimiter', ';');
    case 1
        libpaths = sprintf('%s;', adaptorsToWrite{:});
        com.mathworks.services.Prefs.setStringPref('imaqadaptors', libpaths);
end