function addParamListener(this)
% Adds listener to AllParameters changes

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:41:16 $

L = handle.listener(this,this.findprop('AllParameters'),...
                    'PropertyPostSet',@(x,y) LocalChangeParams(this));
addlisteners(this,L)

%---------- Local Functions ----------------------
function LocalChangeParams(this)
% Resize plot when global parameter list changes
NewParNames = get(this.AllParameters,{'Name'});

% Delete plots whose parameter list is not a subset
% of the new list
this.AxesGrid.LimitManager = 'off';
for ct=1:length(this.Waves)
   w = this.Waves(ct);
   if ~isempty(setdiff(w.DataSrc.Parameters,NewParNames))
      this.rmwave(w)
   end
end
this.AxesGrid.LimitManager = 'on';

% Resize plot
this.resize(NewParNames);

% Update plot visibility
setActivePlots(this)

% Redraw
draw(this)
