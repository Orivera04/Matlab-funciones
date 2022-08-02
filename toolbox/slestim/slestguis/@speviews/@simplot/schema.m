function schema
% Defines class properties

% Author(s): P. Gahinet
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/16 22:21:33 $

p = findpackage('speviews');
c = schema.class(p, 'simplot', findclass(p, 'respplot'));

% Test data
p = schema.prop(c, 'TestData', 'handle');
