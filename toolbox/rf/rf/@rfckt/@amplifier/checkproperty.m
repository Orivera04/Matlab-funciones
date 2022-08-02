function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:36:08 $

checkbaseproperty(h);

% Set the flag for nonlinear
cflag = get(h, 'Flag');
setflagindexes(h);
if bitget(cflag, indexOfNonLinear) == 0
    % Check the IP3
    if ~((get(h, 'IIP3') == inf) && (get(h, 'OIP3') == inf))
        updateflag(h, indexOfNonLinear, 1, MaxNumberOfFlags);
    end
end
if ~(getnport(get(h, 'RFdata')) == 2)
    id = sprintf('rf:%s:checkproperty:TwoPortOnly', strrep(class(h),'.',':'));
    error(id, 'Amplifier only accepts 2-port network parameters.');
end
