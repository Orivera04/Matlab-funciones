function h=xregfigure(varargin)
%XREGFIGURE Create an MBC application figure
%
%  h=xregfigure(prop,value...) creates a modified figure window
%  and returns the UDD handle to it.  Enhancements on the figure
%  include:
% 
%  * Useful default properties:  Doublebuffer     = 'on'
%                                MenuBar          = 'none'
%                                ToolBar          = 'none'
%                                IntegerHandle    = 'off'
%                                Color            = default UI background
%                                NumberTitle      = 'off'
%                                HandleVisibility = 'callback'
%
%  * Automatic resizing.  Use the property 'MinimumSize' to set a minumum
%    [height width] for the figure.  Use the property 'LayoutManager' to 
%    set a layout for the figure which will be repacked during resize.
%    To turn off the resizing function set the property 'ManageResize' to
%    'off'.
%  
%  SEE ALSO: XREGDIALOG

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.4 $  $Date: 2004/02/09 07:34:22 $

h = xregGui.figure(varargin{:});