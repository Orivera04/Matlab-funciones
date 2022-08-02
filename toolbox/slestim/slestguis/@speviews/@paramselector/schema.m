function schema
% Defines properties for @paramselector class

%  Author(s): P. Gahinet
%  Copyright 1986-2004 The MathWorks, Inc.
%  $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:41:27 $

% Find parent class (superclass)
supclass = findclass(findpackage('ctrluis'), 'axesselector');

% Register class (subclass)
c = schema.class(findpackage('speviews'), 'paramselector', supclass);

% Public attributes
schema.prop(c, 'Parent', 'handle'); % Parent plot