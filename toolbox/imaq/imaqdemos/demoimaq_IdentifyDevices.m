%% Identifying Available Devices
%
% Copyright 2001-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/03/24 20:39:26 $

%% Identifying Installed Adaptors
% The IMAQHWINFO function provides a structure with an InstalledAdaptors
% field that lists all adaptors on the current system that the toolbox 
% can access.
imaqInfo = imaqhwinfo
%%
imaqInfo.InstalledAdaptors

%% Obtaining Device Information
% Calling IMAQHWINFO with an adaptor name returns a structure that provides
% information on all accessible image acquisition devices.
matroxInfo = imaqhwinfo('matrox')
%%
matroxInfo.DeviceInfo
%%
% Information on a specific device can be obtained by simply indexing into the device
% information structure array.
device1 = matroxInfo.DeviceInfo(1)
%%
% The DeviceName field contains the image acquisition device name.
device1.DeviceName
%%
% The DeviceID field contains the image acquisition device identifier.
device1.DeviceID
%%
% The DefaultFormat field contains the image acquisition device's default video
% format.
device1.DefaultFormat
%%
% The SupportedFormats field contains a cell array of all valid video formats
% supported by the image acquisition device.
device1.SupportedFormats
%%
% See also IMAQHWINFO, IMAQRESET, IMAQHELP.