function addlisteners(this, L)
% ADDLISTENERS Installs listeners.

% Author(s): Bora Eryilmaz
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/16 22:21:35 $

h = this.Estimation;

if nargin == 1
  % Install built-in listeners
  L = handle.listener( h, 'EstimUpdate', @(x,y) LocalUpdate(this));
end

this.Listeners = [this.Listeners ; L];

% ----------------------------------------------------------------------------%
function LocalUpdate(this)
% Clear dependent data
reset(this)
% Notify peers
this.send('SourceChanged')
