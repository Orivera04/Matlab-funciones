function verify(this)
% VERIFY 
% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:43:16 $


function flag = portcheck(this)
% PORTCHECK  Check compatibility of model ports with port data
%

flag  = false;
model = this.Model;

try
  feval(model,[],[],[],'compile');
  flag = LocalComparePorts( this );
  feval(model,[],[],[],'term');
catch
  feval(model,[],[],[],'term')
end

    
% --------------------------------------------------------------------------- %
function flag = LocalComparePorts(this)
inports  = find_system(this.Model, 'SearchDepth', 1, 'BlockType', 'Inport');
outports = find_system(this.Model, 'SearchDepth', 1, 'BlockType', 'Outport');
Blocks   = [inports; outports];

h = [this.Inputs; this.Outputs];

flag = true;

% Check ports
for k = 1:length(h)
  % Find matching port and get information.
  idx = find( strcmp( h(k).Block, Blocks ) );
  if isempty(idx)
    fprintf('\nPort does not exist.');
    fprintf('\nCheck port: %s\n', h(k).Block);
    flag = false;
    return
  end
  
  widths = get_param(Blocks{idx}, 'CompiledPortDimensions');
  type   = get_param(Blocks{idx}, 'BlockType');
  
  if any( strcmp(type, {'Inport', 'Signal'} ) )
    dims = widths.Outport(2:end);
  elseif strcmp(type, 'Outport')
    dims = widths.Inport(2:end);
  end
  
  % Size of the ports of the blocks
  if h(k).Dimensions ~= dims
    fprintf('\nPort width mismatch between port data and model ports.');
    fprintf('\nCheck %s port #: %d\n', type, k);
    flag = false;
    return
  end
end
