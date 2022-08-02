function schema
% Defines properties for @respdata class
% Logs all output data for a given estimation

%  Author(s): P. Gahinet
%  Copyright 1986-2002 The MathWorks, Inc.
%  $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:21:05 $

% Find parent class (superclass)
supclass = findclass(findpackage('wrfc'), 'data');

% Register class (subclass)
c = schema.class(findpackage('speviews'), 'respdata', supclass);

% Nport x Nexp struct array with fields Time and Amplitude 
schema.prop(c, 'SimData', 'MATLAB array');  
