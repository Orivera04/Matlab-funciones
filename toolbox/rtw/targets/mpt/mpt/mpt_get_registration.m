function result = mpt_get_registration(registrationCode)

% Copyright 2002-2003 The MathWorks, Inc.

global mptRegistration;
result = [];
if isfield(mptRegistration,registrationCode) == 1
    result = getfield(mptRegistration,registrationCode);
end

