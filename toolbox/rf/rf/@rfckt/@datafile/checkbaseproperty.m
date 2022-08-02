function checkbaseproperty(h)
%CHECKBASEPROPERTY Check the properties of the object.
%   CHECKBASEPROPERTY(H) checks the properties of the object.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:36:27 $

% Get the RFDATA.DATA object 
data = get(h, 'RFdata');
file = get(h, 'File');

% Check the file name
if isempty(file) && (~isa(data, 'rfdata.data') || ~isa(data.Reference, 'rfdata.reference'))
    id = sprintf('rf:%s:checkbaseproperty:EmptyFile',strrep(class(h),'.',':'));
    error(id, 'The property FILE should not be empty.');
end

% Check the property of data object
if isa(data, 'rfdata.data')
    checkproperty(data);
else
    id = sprintf('rf:%s:checkbaseproperty:NotARFDataObject', ...
        strrep(class(h),'.',':'));
    error(id, 'The property RFDATA must be an RFDATA.DATA object.');
end

% Set the flag for nonlinear
setflagindexes(h);
updateflag(h, indexOfNonLinear, 0, MaxNumberOfFlags);
if isa(data, 'rfdata.data')
    refobj = get(data, 'Reference');
    if isa(refobj, 'rfdata.reference')
        powerdata = get(refobj, 'PowerData'); 
    else
        powerdata = [];
    end
    if isa(powerdata, 'rfdata.power')
        updateflag(h, indexOfNonLinear, 1, MaxNumberOfFlags);
        return;
    end
end

% Check Freq and S-params
if isempty(get(data, 'Freq')) 
    id = sprintf('rf:%s:checkbaseproperty:NoFreq', strrep(class(h),'.',':'));
    error(id, 'FREQ of RFDATA should not be empty.'); 
end
if isempty(get(data, 'S_Parameters'))
    id = sprintf('rf:%s:checkbaseproperty:NoSParameters', strrep(class(h),'.',':'));
    error(id, 'S_PARAMETERS of RFDATA should not be empty.'); 
end
