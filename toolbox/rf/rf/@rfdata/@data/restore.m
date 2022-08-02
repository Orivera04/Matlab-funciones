function restore(h)
%RESTORE Restore the object's properties from the REFERENCE object.
%   RESTORE(H) restores the properties from the REFERENCE object. H is the
%   handle to the RFDATA.DATA object.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:38:25 $

% Get the Reference
refobj = get(h, 'Reference');
if isa(refobj, 'rfdata.reference')
    % get the Networkdata
    netdata = get(refobj, 'NetworkData');
    if isa(netdata, 'rfdata.network')
        if isempty(get(netdata, 'Freq')) || isempty(get(netdata, 'Data'))
            set(h, 'Freq', [], 'S_Parameters', []);
        else
            % Get the FREQ and extract S-parameters
            freq = get(netdata, 'Freq');
            sparams = extract(netdata, 'S_PARAMETERS');
            z0 = get(netdata, 'Z0');
            % Update the properties
            set(h, 'Freq', freq, 'S_Parameters', sparams, 'Z0', z0);
        end
    else
        set(h, 'Freq', [], 'S_Parameters', []);
    end
end
