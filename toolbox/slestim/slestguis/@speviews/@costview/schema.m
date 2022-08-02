function schema
% Defines properties for @costview class

% Copyright 1986-2002 The MathWorks, Inc. 
% $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:20:49 $

superclass = findclass(findpackage('wavepack'), 'timeview');
c = schema.class(findpackage('speviews'), 'costview', superclass);
