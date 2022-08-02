function PortNames = utGetPortNames(OutputPorts)
% Get port names fro port handle or Outport block handle.

% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:21:46 $
PortNames = get(OutputPorts,{'Name'});
for ct=1:length(PortNames)
   if isempty(PortNames{ct})
      % Use blockname/portnumber
      p = OutputPorts(ct);
      PortNames{ct} = sprintf('%s/%d',...
         strrep(get_param(get(p,'Parent'),'Name'),sprintf('\n'),' '),...
         get(p,'PortNumber'));
   end
end
