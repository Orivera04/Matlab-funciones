function varargout = aeroblkisa(action)
%  AEROBLKISA - Aerospace Blockset ISA and lapse rate atmosphere model 
%  block helper function for mask parameters.

% Copyright 1990-2003 The MathWorks, Inc.
% $Revision $ $Date: 2004/04/06 01:04:09 $

if nargin == 0, 
    action = 'dynamic'; 
end

blk = gcb;

switch action
case 'icon'
    set_up_mask(blk);  
    varargout = { 'no output' };
case 'dynamic'
    set_up_mask(blk); 
otherwise
   error('aeroblks:aeroblkisa:invalidiconaction','Icon action not defined');
end
return
%--------------------------------------------------------------------------
function set_up_mask(blk)

    mask_visible = get_param(blk,'maskvisibilities');  % remove non-options
   
   % Determine determine if model has variable parameters
    Vparam = get_param(blk,'custom');
 
   if strcmp(Vparam,'on')
       if ~strcmp(mask_visible(2),'on')
           [mask_visible{2:10}]=deal('on');
           set_param(blk,'MaskHelp','web(asbhelp(''Lapse Rate Model''));')
       end
   else
       if ~strcmp(mask_visible(2),'off')
           [mask_visible{2:10}]=deal('off');
           % reset parameters to isa model
           set_param(blk,'g','9.80665');
           set_param(blk,'gamma','1.4');
           set_param(blk,'R','287.0531');
           set_param(blk,'L','0.0065');
           set_param(blk,'h_trop','11000');
           set_param(blk,'h_strat','20000');
           set_param(blk,'rho0','1.225');
           set_param(blk,'P0','101325');
           set_param(blk,'T0','288.15');
           set_param(blk,'MaskHelp','web(asbhelp(''isaatmospheremodel''));')
       end
   end
  
   set_param(blk,'maskvisibilities',mask_visible);
return