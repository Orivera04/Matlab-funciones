function  custom_user_type_registration
%CUSTOM_USER_TYPE_REGISTRATION data-type registration for user-defined data types
% 
%   CUSTOM_USER_TYPE_REGISTRATION()
%   This function registers the user data types, and associates them with
%   Mathworks data types.
%
%   INPUTS:
%             none
%
%   OUTPUTS: 
%             none
%
% To register each user data type, type a utype_register function call.
% Use the format of the examples below to register each user data type:
% utype_register('real32_T',  'userfloat',   'primary', '<userdata_types.h>','Both');
% utype_register('real32_T',  'userDatType1',   'secondary', '<userdata_types.h>','Parameter');
% utype_register('real_T',    'userDatType2',   'primary', '<userdata_types.h>','Signal');
% utype_register('real_T',    'userDatType3',   'primary', '<userdata_types.h>');
%
% The fourth argument in utype_register function call is optional. Missing it or 'Both' mean
% that the registered user data type is suitable for both parameter and signal. 
% 
% The Mathworks data types are:
%     real_T       
%     real32_T
%     int8_T
%     uint8_T
%     int16_T
%     uint16_T
%     int32_T
%     uint32_T
%     boolean_T


%   Copyright 2001-2003 The MathWorks, Inc.
%   $Revision: 1.9.4.5 $
%   $Date: 2004/04/15 00:29:24 $

utype_establish;  %Do not delete this function call.

%% You may modify code below by uncommenting code lines 

% utype_register('real32_T',  'userfloat',   'primary', '<userdata_types.h>','Both');
% utype_register('real32_T',  'userDatType1',   'secondary', '<userdata_types.h>','Parameter');
% utype_register('real_T',    'userDatType2',   'primary', '<userdata_types.h>','Signal');
% utype_register('int8_T',    'userDatType3',   'primary', '<userdata_types.h>');
