function [Ports,PortSizes] = getPortHandles(this,NoSort)
% Get handles of all output ports involved in a given set of experiments

% Author(s): P. Gahinet
% Copyright 1986-2001 The MathWorks, Inc. 
% $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:21:53 $
Ports = [];
PortSizes = cell(0,1);
for ct=1:length(this)
   exp = this(ct);
   for cto=1:length(exp.OutputData)
      outdata = exp.OutputData(cto);
      if strcmp(get_param(outdata.Block,'BlockType'),'Outport')
         % Outport block
         Ports = [Ports ; get_param(outdata.Block,'Handle')];
      else
         % Output port of other block types
         ph = get_param(outdata.Block,'PortHandles');
         Ports = [Ports ; ph.Outport(outdata.PortNumber)];
      end
      PortSizes = [PortSizes ; {outdata.Dimensions}];
   end
end

if nargin==1
   % sort + unique
   [Ports,iu] = unique(Ports);
   PortSizes = PortSizes(iu);
end