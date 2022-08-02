function schema
%SCHEMA  Class definition for @respplot (base class for @simplot and @residplot)

%  Copyright 1986-2002 The MathWorks, Inc. 
%  $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:21:16 $
cplot = findclass(findpackage('resppack'), 'respplot');
c = schema.class(findpackage('speviews'), 'respplot', cplot);

% Output port handles and port sizes
schema.prop(c, 'OutputPort', 'MATLAB array');
schema.prop(c, 'OutputPortSize', 'MATLAB array');

% Time focus (inherited from test data)
schema.prop(c, 'TimeFocus', 'MATLAB array');
