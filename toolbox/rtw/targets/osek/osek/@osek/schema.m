function schema()
%SCHEMA  Package constructor function.

%   Copyright 1994-2002 The MathWorks, Inc.
%   $Revision: 1.3 $  $Date: 2002/12/05 18:03:14 $

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

%%%% Construct package
schema.package('osek');

%%%% Create user-defined enumerated string types
if isempty(findtype('osek_debugger'))
  schema.EnumType('osek_debugger', {
    'SingleStep';
    'Custom';});
else
  warning('A type named ''osek_debugger'' already exists.');
end

if isempty(findtype('osek_implementation'))
  schema.EnumType('osek_implementation', {
    'ProOSEK';
    'OSEKWorks';
   });
else
  warning('A type named ''osek_debugger'' already exists.');
end

%%%% Create user-defined enumerated string types
