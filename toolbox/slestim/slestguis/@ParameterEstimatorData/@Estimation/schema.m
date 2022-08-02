function schema
% SCHEMA  Defines properties for GUI estimation data class

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:37:31 $

% Find parent package
pkg = findpackage('speguidata');

% Register class (subclass)
c = schema.class(pkg, 'estimation');

% Properties parallel to slestim.estimation object
schema.prop(c, 'Name',       'string');         % Parameter name
schema.prop(c, 'Dimensions', 'string');   % Port width
schema.prop(c, 'Data',       'string');         % Port data
schema.prop(c, 'Units',      'string vector');  % Port data units
schema.prop(c, 'Tstart',     'string');         % Start time
schema.prop(c, 'Tstop',      'string');         % Stop time
schema.prop(c, 'Ts',         'string');         % Sampling time
schema.prop(c, 'Time',       'string');         % Time data (matrix)
schema.prop(c, 'TimeUnit',   'string');         % 'sec'
schema.prop(c, 'Period',     'string');         % Signal period
schema.prop(c, 'InterSample','string');         % 'zoh', 'foh'
schema.prop(c, 'PortType',   'string');         %
schema.prop(c, 'Description','string');         %
