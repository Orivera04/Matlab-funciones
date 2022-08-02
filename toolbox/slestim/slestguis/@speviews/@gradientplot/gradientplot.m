function this = gradientplot(fig,ParamList,varargin)
% GRADIENTPLOT Constructor
%
%  H = GRADIENTPLOT(FIG,PARAMLIST) creates a sensitivity plot 
%  with one axis per estimated parameter listed in PARAMLIST.

%  Author(s): Bora Eryilmaz
%  Copyright 1986-2004 The MathWorks, Inc.
%  $Revision: 1.1.6.4 $ $Date: 2004/04/16 22:20:54 $

% Create class instance
this = speviews.gradientplot;
this.AllParameters = ParamList;
Np = length(ParamList);
if Np==0
   ChannelName = cell(0,1);
   ChannelVisible = cell(0,1);
else
   ChannelName = get(ParamList,{'Name'});
   ChannelVisible = repmat({'off'},[Np 1]);
end

% Initialize the handle graphics objects used in the class.
this.initialize( fig, ...
                 'ChannelName', ChannelName,...
                 'ChannelVisible', ChannelVisible,...
                 varargin{:} );

% Customization
this.AxesGrid.Title  = 'Goodness-of-Fit Sensitivity to Estimated Parameters';
this.AxesGrid.YLabel = 'Parameter Sensitivity';

% Make visible
this.Visible = 'on';

% Add listener to AllParameters
addParamListener(this)

% Add menus
setmenus(this)
