function [indexOn, indexOff] = getparamindex(varargin)
%GETPARAMINDEX Get the visibilities/enables information of parameters
%   [IDEXON, IDEXOFF, IDEXENABON, IDEXENABOFF] = GETPARAMINDEX(VARARGIN)
%   gets the visibilities/enables information of 3 different parameters for
%   block mask functions.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:40:17 $

% Get the inputs
PlotType = varargin{1};
idxSmithData = varargin{2};
idxPolarData = varargin{3};
idxNetworkData = varargin{4};

if nargin == 6
    idxPowerData = varargin{5};
    powerdata = varargin{6};
    % Set the visibilities/enables of 3 different parameters
    switch PlotType
    case {'Z Smith chart' 'Y Smith chart' 'ZY Smith chart'}
        indexOn = idxSmithData;
        indexOff = [idxPolarData idxNetworkData idxPowerData];
    case 'Polar plane'
        indexOn = idxPolarData;
        indexOff = [idxSmithData idxNetworkData idxPowerData];
    otherwise
        if powerdata
            indexOn = idxPowerData;
            indexOff = [idxPolarData idxSmithData idxNetworkData];
        else
            indexOn = idxNetworkData;
            indexOff = [idxPolarData idxSmithData idxPowerData];
        end
    end
else    % Set the visibilities/enables of 3 different parameters
    switch PlotType
    case {'Z Smith chart' 'Y Smith chart' 'ZY Smith chart'}
        indexOn = idxSmithData;
        indexOff = [idxPolarData idxNetworkData];
    case 'Polar plane'
        indexOn = idxPolarData;
        indexOff = [idxSmithData idxNetworkData];
    otherwise
        indexOn = idxNetworkData;
        indexOff = [idxPolarData idxSmithData];
    end
end
