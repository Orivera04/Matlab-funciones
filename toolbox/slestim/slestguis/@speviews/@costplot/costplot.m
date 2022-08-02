function h = costplot(fig,varargin)
% COSTPLOT Constructor
%
%  H = COSTPLOT(FIG) creates a @costplot object.
%
%  H = COSTPLOT(FIG,'Property1','Value1',...) initializes the plot 
%  with the specified attributes.

%  Author(s): Bora Eryilmaz
%  Copyright 1986-2004 The MathWorks, Inc.
%  $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:40:53 $

% Create class instance
h = speviews.costplot;

% Initialize the handle graphics objects used in the class.
h.initialize( fig, varargin{:} );

% Make visible
h.Visible = 'on';

% Add menus
setmenus(h)
