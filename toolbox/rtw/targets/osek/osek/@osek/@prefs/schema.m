function schema()
%SCHEMA  Class constructor function (for osek.prefs).

%   Copyright 1994-2003 The MathWorks, Inc.
%   $Revision: 1.5.6.1 $  $Date: 2004/04/19 01:30:46 $

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE:
% - This file was automatically generated by the Simulink data class designer.
% - The contents of this file are arranged so that the Simulink data class
%   designer can load the associated classes for editing.
% - Hand modification of this file is not recommended as it may prevent the
%   Simulink class designer from loading the associated classes.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - Generated on:   05-Sep-2002 09:05:29
% - MATLAB version: 6.5.0.183862a (R13)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Get handles of associated packages and classes
hDeriveFromPackage = findpackage('RTW');
hDeriveFromClass   = findclass(hDeriveFromPackage, 'TargetPrefs');
hCreateInPackage   = findpackage('osek');

%%%% Construct class
hThisClass = schema.class(hCreateInPackage, 'prefs', hDeriveFromClass);

%%%% Add properties to this class
hThisProp = schema.prop(hThisClass, 'Implementation', 'osek_implementation');
hThisProp.AccessFlags.Init = 'on';
hThisProp.FactoryValue = 'OSEKWorks';

hThisProp = schema.prop(hThisClass, 'ImpPath', 'string');
hThisProp.AccessFlags.Init = 'on';
hThisProp.FactoryValue = 'c:\wind\TornadoOW_ppc_3.0';

hThisProp = schema.prop(hThisClass, 'StaticLibraryDirectory', 'string');
hThisProp.AccessFlags.Init = 'on';
hThisProp.FactoryValue = fullfile(matlabroot, 'toolbox', 'rtw', ...
				  'targets', 'osek', 'lib', '');

hThisProp = schema.prop(hThisClass, 'ToolChain', 'handle');
hThisProp.GetFunction = @ToolChainOptionsGet;
hThisProp.AccessFlags.Serialize = 'off';

hThisProp = schema.prop(hThisClass, 'ToolChainOptions', 'handle');
hThisProp.AccessFlags.PublicSet='off';
hThisProp.AccessFlags.PublicGet='off';
