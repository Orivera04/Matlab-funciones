function mapfile = slestguihelp(topickey)
% SLESTGUIHELP Help support for Simulink Parameter Estimation GUI.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:42:05 $

% Get MAPFILE name
helpdir = docroot;
if ~isempty(helpdir)
  mapfile = sprintf('%s/mapfiles/slestim.map', helpdir);
else
  mapfile = '';
end

if nargin
  % Pass help topic to help browser
  try
    helpview(mapfile, topickey);
  end
end
