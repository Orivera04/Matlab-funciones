function mpt_set_registration(registrationCode, value)

% Copyright 2002 The MathWorks, Inc.

global mptRegistration;

mptRegistration = setfield(mptRegistration,registrationCode,value);


