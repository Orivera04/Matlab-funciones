function [idxOn, idxOff, idxEnabOn, idxEnabOff] = getformatindex(varargin)
%GETFORMATINDEX Get the visibilities/enables information of formats
%   [IDEXON, IDEXOFF, IDEXENABON, IDEXENABOFF] = GETFORMATINDEX(VARARGIN)
%   gets the visibilities/enables information of 3 different formats for
%   block mask functions.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $  $Date: 2004/04/12 23:40:16 $

% Get the inputs
parameter = varargin{1};
PlotType = varargin{2};
indexComplex = varargin{3};
indexDb = varargin{4};
indexNone = varargin{5};

% Set the defaults
idxOn = [];     idxOff = [];     idxEnabOn = [];    idxEnabOff = [];

% Set the visibilities/enables of 3 formats
if nargin == 6
    indexDbm = varargin{6};
switch PlotType
    case {'Polar plane' 'Z Smith chart' 'Y Smith chart' 'ZY Smith chart'}
        switch parameter
        case {'S11' 'S21' 'S12' 'S22' 'GammaOpt' 'GammaIn' 'GammaOut'}
            idxOn = [indexNone];
            idxOff = [indexComplex indexDb indexDbm];
            idxEnabOff = [indexNone];
         case {'VSWRIn' 'VSWROut' 'NF'}
            idxOn = [indexNone];
            idxOff = [indexComplex indexDb indexDbm];
            idxEnabOff = [indexNone];
         otherwise 
            idxOn = [indexComplex];
            idxOff = [indexDb indexNone indexDbm];
            idxEnabOff = [indexComplex];
        end
    case {'X-Y plane' 'Link budget'}
        switch parameter
        case {'S11' 'S21' 'S12' 'S22' 'GammaOpt' 'GammaIn' 'GammaOut'}
            idxOn = [indexComplex];
            idxOff = [indexDb indexNone indexDbm];
        case {'VSWRIn' 'VSWROut' 'NF'}
            idxOn = [indexDb];
            idxOff = [indexComplex indexNone indexDbm];
        case 'OIP3'
            idxOn = [indexDbm];
            idxOff = [indexComplex indexNone indexDb];
        otherwise 
            idxOn = [indexComplex];
            idxOff = [indexDb indexNone indexDbm];
        end
    case 'Composite data'
        idxOn = [indexNone];
        idxOff = [indexComplex indexDb indexDbm];
        idxEnabOff = [indexNone];
    end
elseif nargin == 7
    indexDbc = varargin{7};
switch PlotType
    case {'Polar plane' 'Z Smith chart' 'Y Smith chart' 'ZY Smith chart'}
        switch parameter
        case {'S11' 'S21' 'S12' 'S22' 'GammaOpt' 'GammaIn' 'GammaOut'}
            idxOn = [indexNone];
            idxOff = [indexComplex indexDb indexDbc];
            idxEnabOff = [indexNone];
         case {'VSWRIn' 'VSWROut' 'NF'}
            idxOn = [indexNone];
            idxOff = [indexComplex indexDb indexDbc];
            idxEnabOff = [indexNone];
         otherwise 
            idxOn = [indexComplex];
            idxOff = [indexDb indexNone indexDbc];
            idxEnabOff = [indexComplex];
        end
    case {'X-Y plane' 'Link budget'}
        switch parameter
        case {'S11' 'S21' 'S12' 'S22' 'GammaOpt' 'GammaIn' 'GammaOut'}
            idxOn = [indexComplex];
            idxOff = [indexDb indexNone indexDbc];
        case {'VSWRIn' 'VSWROut' 'NF'}
            idxOn = [indexDb];
            idxOff = [indexComplex indexNone indexDbc];
        case 'PhaseNoise'
            idxOn = [indexDbc];
            idxOff = [indexComplex indexNone indexDb];
        otherwise 
            idxOn = [indexComplex];
            idxOff = [indexDb indexNone indexDbc];
        end
    case 'Composite data'
        idxOn = [indexNone];
        idxOff = [indexComplex indexDb indexDbc];
        idxEnabOff = [indexNone];
    end
elseif nargin == 9
    indexPower = varargin{8};
    indexPhase = varargin{9};
switch PlotType
    case {'Polar plane' 'Z Smith chart' 'Y Smith chart' 'ZY Smith chart'}
        switch parameter
        case {'S11' 'S21' 'S12' 'S22' 'GammaOpt' 'GammaIn' 'GammaOut'}
            idxOn = [indexNone];
            idxOff = [indexComplex indexDb indexPower indexPhase];
            idxEnabOff = [indexNone];
         case {'VSWRIn' 'VSWROut' 'NF'}
            idxOn = [indexNone];
            idxOff = [indexComplex indexDb indexPower indexPhase];
            idxEnabOff = [indexNone];
         otherwise 
            idxOn = [indexComplex];
            idxOff = [indexDb indexNone indexPower indexPhase];
            idxEnabOff = [indexComplex];
        end
    case {'X-Y plane' 'Link budget'}
        switch parameter
        case {'S11' 'S21' 'S12' 'S22' 'GammaOpt' 'GammaIn' 'GammaOut'}
            idxOn = [indexComplex];
            idxOff = [indexDb indexNone indexPower indexPhase];
        case {'VSWRIn' 'VSWROut' 'NF' 'AM/AM'}
            idxOn = [indexDb];
            idxOff = [indexComplex indexNone indexPower indexPhase];
        case 'Pout'
            idxOn = [indexPower];
            idxOff = [indexComplex indexNone indexDb indexPhase];
        case {'Phase' 'AM/PM'}
            idxOn = [indexPhase];
            idxOff = [indexComplex indexNone indexDb indexPower];
        otherwise 
            idxOn = [indexComplex];
            idxOff = [indexDb indexNone indexPower indexPhase];
        end
    case 'Composite data'
        idxOn = [indexNone];
        idxOff = [indexComplex indexDb indexPower indexPhase];
        idxEnabOff = [indexNone];
    end
else
    switch PlotType
    case {'Polar plane' 'Z Smith chart' 'Y Smith chart' 'ZY Smith chart'}
        switch parameter
        case {'S11' 'S21' 'S12' 'S22' 'GammaOpt' 'GammaIn' 'GammaOut'}
            idxOn = [indexNone];
            idxOff = [indexComplex indexDb];
            idxEnabOff = [indexNone];
         case {'VSWRIn' 'VSWROut'}
            idxOn = [indexNone];
            idxOff = [indexComplex indexDb];
            idxEnabOff = [indexNone];
         otherwise 
            idxOn = [indexComplex];
            idxOff = [indexDb indexNone];
            idxEnabOff = [indexComplex];
        end
    case 'X-Y plane'
        switch parameter
        case {'S11' 'S21' 'S12' 'S22' 'GammaOpt' 'GammaIn' 'GammaOut'}
            idxOn = [indexComplex];
            idxOff = [indexDb indexNone];
        case {'VSWRIn' 'VSWROut' 'NF'}
            idxOn = [indexDb];
            idxOff = [indexComplex indexNone];
        otherwise 
            idxOn = [indexComplex];
            idxOff = [indexDb indexNone];
        end
    case 'Composite data'
        idxOn = [indexNone];
        idxOff = [indexComplex indexDb];
        idxEnabOff = [indexNone];
    end
end