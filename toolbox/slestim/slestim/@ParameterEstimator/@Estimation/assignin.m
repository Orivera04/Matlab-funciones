function assignin(this,Params)
% Assigns parameter values in appropriate workspace.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/03/24 21:12:05 $

util = slcontrol.Utilities;

% Assign values only to variables with estimated elements.
if ~isempty(Params)
  Params = find( Params, '-function', 'Estimated', @(x) any(x(:)) );
end
pnames = get(Params, {'Name'});
ps = struct( 'Name',      pnames, ...
             'Value',     get(Params, {'Value'}), ...
             'Workspace', util.findParametersWS(this.Model, pnames) );

% Perform assignment
util.assignParameters(this.Model, ps)
