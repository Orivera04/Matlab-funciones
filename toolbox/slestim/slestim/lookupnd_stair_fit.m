function varargout = lookupnd_stair_fit(action, varargin)
% LOOKUPND_STAIR_FIT Dialog editor for adaptive lookup table blocks

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:43:58 $

blk = gcb;
MaskEnables = get_param(blk, 'MaskEnables');
MaskNames   = get_param(blk, 'MaskNames');

switch action
case 'Parameters'
  Tb_NumDims = varargin{1};
  Bp_Cell    = varargin{2};
  
  % For empty breakpoint set or vector data for 1D tables, respectively.
  if isempty(Bp_Cell)
    Bp_Cell = cell(Tb_NumDims,1);
  elseif ~iscell(Bp_Cell)
    Bp_Cell = {Bp_Cell}; 
  end
  
  % Vectorize breakpoint data and determine length of each breakpoint set.
  for ct = 1:length(Bp_Cell)
    if ct == 1
      Bp_Data  = Bp_Cell{ct}(:);
      Bp_Index = length(Bp_Cell{ct}(:));
    else
      Bp_Data  = [Bp_Data  ; Bp_Cell{ct}(:)];
      Bp_Index = [Bp_Index ; length(Bp_Cell{ct}(:))];
    end
  end
  varargout = {Bp_Data, Bp_Index};

case 'Icon'
  % Input port labels
  si(1).port = 1; si(1).txt = 'u';
  si(2).port = 2; si(2).txt = 'y';
  
  if strcmp( get_param(blk, 'Tb_Input'), 'on' )
    si(3).port = si(2).port + 1; si(3).txt = 'Tin';
  else
    si(3) = si(2); % no table input port
  end
  
  if strcmp( get_param(blk, 'Ad_Enable'), 'on' )
    si(4).port = si(3).port + 1; si(4).txt = 'Enable';
  else
    si(4) = si(3); % no adaptation enable port
  end
  
  if strcmp( get_param(blk, 'Ad_Lock'), 'on' )
    si(5).port = si(4).port + 1; si(5).txt = 'Lock';
  else
    si(5) = si(4); % no cell lock port
  end
  
  % Output port labels
  so(1).port = 1; so(1).txt = 'y';
  so(2).port = 2; so(2).txt = 'N';

  if strcmp( get_param(blk, 'Tb_Output'), 'on' )
    so(3).port = so(2).port + 1; so(3).txt = 'Tout';
  else
    so(3) = so(2); % no table output port
  end
  
  % Title string
  st = sprintf('%d-D T(u)', varargin{1});
  varargout = {si, so, st};
  
case 'TableInput'
  % Enable/disable table data field.
  idx = find( strcmp(MaskNames, 'Tb_Data') );
  if strcmp( get_param(blk, 'Tb_Input'), 'on' )
    MaskEnables{idx} = 'off';
  else
    MaskEnables{idx} = 'on';
  end
  
case 'AdaptMethod'
  % Enable/disable adaptation gain field.
  idx = find( strcmp(MaskNames, 'Ad_Factor') );
  if strcmp( get_param(blk, 'Ad_Method'), 'Sample mean' )
    MaskEnables{idx} = 'off';
  else
    MaskEnables{idx} = 'on';
  end
end

set_param(blk, 'MaskEnables', MaskEnables);
