function this = paramplot(fig, ParamList, varargin)
% Constructor
%
%  H = PARAMPLOT(FIG,PARAMLIST) creates a parameter trajectory 
%  plot with one axis per estimated parameter listed in PARAMLIST.

%  Author(s): Bora Eryilmaz
%  Copyright 1986-2004 The MathWorks, Inc.
%  $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:41:21 $

% Create class instance
this = speviews.paramplot;
this.AllParameters = ParamList;
Np = length(ParamList);
if Np==0
  ChannelName = cell(0,1);
  ChannelVisible = cell(0,1);
else
  ChannelName = get( ParamList, {'Name'} );
  ChannelVisible = repmat({'off'}, [Np 1]);
end

% Initialize the handle graphics objects used in the class.
this.initialize( fig, ...
                 'ChannelName', ChannelName,...
                 'ChannelVisible', ChannelVisible,...
                 varargin{:} );

% Make visible
this.Visible = 'on';

% Add listener to AllParameters
addParamListener(this)

% Add menus
setmenus(this)
