function schema
% Defines properties for @paramview class

%  Author(s): Bora Eryilmaz
%  Copyright 1986-2002 The MathWorks, Inc. 
%  $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:21:25 $

% Register class
superclass = findclass(findpackage('wrfc'), 'view');
c = schema.class(findpackage('speviews'), 'respview', superclass);

% Log plots
% Nport x Nexp cell array of curves
schema.prop(c, 'SimPlot', 'MATLAB array');  

% Nport x 1 cell array of port sizes
schema.prop(c, 'PortSize', 'MATLAB array');  
