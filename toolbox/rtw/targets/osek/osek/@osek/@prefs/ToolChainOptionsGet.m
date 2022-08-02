% File : ToolChainOptionsGet
% 
% Abstract :
%   Access method for ToolChain. Assures that
%   ToolChain is not null. Poulate it with factory default of
%   osek.ToolChain if it is null. 

%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 2003/01/10 16:52:14 $
function out = ToolChainOptionsGet(h,val)

  if isempty(h.ToolChainOptions)
    h.ToolChainOptions = osek.ToolChain;
  end

  out = h.ToolChainOptions;
