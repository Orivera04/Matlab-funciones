function help(h)
%HELP Provide help for OSEK Target Preferences

%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $
%   $Date: 2003/09/14 13:58:09 $

  packageName = strtok(h.class, '.');
  helpview([docroot, '/toolbox/osek/', packageName, '.map'], [packageName, '_set_target_prefs']);
