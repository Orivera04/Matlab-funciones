function schema
% Defines properties for @paramdata class

%  Author(s): Bora Eryilmaz
%  Copyright 1986-2002 The MathWorks, Inc.
%  $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:20:45 $

% Find parent class (superclass)
supclass = findclass(findpackage('wavepack'), 'timedata');

% Register class (subclass)
c = schema.class(findpackage('speviews'), 'costdata', supclass);
