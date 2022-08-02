function setdefaultplotmask(block)
% Set the default of block parameters visibilities/enables for plot

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:40:18 $

% Get variables of the blok
En    = get_param(block, 'MaskEnables');
Vis   = get_param(block, 'MaskVisibilities');

% Set index to mask parameters
setblockfieldindexes(block);

% Set visibilities/enables
idxOn = [idxDisplayData idxFreq idxAllPlotType idxNetworkData idxDBFormat];
idxOff = [idxSmithData idxPolarData idxComplexFormat idxNoneFormat];
idxEnabOff = [idxFreq idxAllPlotType idxNetworkData idxDBFormat];

if ~isempty(idxOn) 
    [En{idxOn}, Vis{idxOn}]  = deal('on');
end
if ~isempty(idxOff) 
    [En{idxOff}, Vis{idxOff}]  = deal('off');
end
if ~isempty(idxEnabOff) 
    [En{idxEnabOff}]  = deal('off');
end

set_param(block, 'MaskVisibilities', Vis, 'MaskEnables', En);
