function hc12_setsfunrtwdata(rtwDataStruct)
%HC12_SETSFUNRTWDATA
%  For the HC12 target, copy data from a Mask Initilization callback
%  executed by a driver S-functions parent subsystem into a block 
%  containing a special Tag 'HC12DriverData'
% 
%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $
%   $Date: 2004/04/19 01:23:21 $

    if ~(nargin==1)
        errmsg = 'Incorrect number of input arguments to hc12_setsfunrtwdata';
        error(errmsg);
    end
    % Insure that it is a cell.
    typeCheck = isa(rtwDataStruct,'struct');
    if ~(typeCheck==1)
        errmsg = 'The function hc12_setsfunrtwdata requires a struct';
        error(errmsg);
    end

    hc12DriverDataBlock = find_system(gcb,'FollowLinks','on','LookUnderMasks','all','Tag','HC12DriverData');
    set_param(hc12DriverDataBlock{1},'RTWData',rtwDataStruct);