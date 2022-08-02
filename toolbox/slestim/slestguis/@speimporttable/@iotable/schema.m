function schema
% SCHEMA Defines class properties
%
%   Authors: James G. Owen
%   Copyright 1986-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2003/12/22 00:56:04 $

% Target type
% if isempty(findtype('IOTarget'))
%     schema.EnumType('IOTarget', {'input','output','state'});
% end

% Get handles of associated packages and classes
hCreateInPackage = findpackage('speimporttable');
hSupClass = findclass(findpackage('sharedlsimgui'), 'abstractimporttable');

% Construct class
c = schema.class(hCreateInPackage, 'iotable',hSupClass);

% ---------------------------------------------------------------------------- %
% Define class properties
% ---------------------------------------------------------------------------- %
% Handle of the node corresponding to the importer target table
p = schema.prop( c, 'Explorer', ....
    'com.mathworks.toolbox.control.explorer.Explorer' );
set( p, 'AccessFlags.PublicSet', 'off', ...
        'AccessFlags.Serialize', 'off' );
p = schema.prop( c, 'ImportSelector', 'handle' );
set( p, 'AccessFlags.PublicSet', 'off', ...
        'AccessFlags.Serialize', 'off' );
    
