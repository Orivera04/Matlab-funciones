function [m,ok] = gui_globalmodsetup(m,action,varargin);
%GUI_GLOBALMODSETUP GUI for altering xregmultilin settings
%
%  [M,OK]=GUI_GLOBALMODSETUP(M) creates a blocking GUI for choosing the
%  subclass of linearmodel and altering its settings.  OK indicates whether
%  the user pressed 'OK' or 'Cancel'.
%
%  LYT=GUI_GLOBALMODSETUP(M,'layout',FIG,P) creates a layout in figure FIG,
%  using the dynamic copy of a model in P.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.4.3 $  $Date: 2004/02/09 07:55:31 $

% Use parent editor but specify that models cannot be edited in a way that
% changes their class
if nargin<2
    action='figure';
end

switch lower(action)
    case 'figure'
        [m.xregmulti, ok] = gui_globalmodsetup(m.xregmulti, action, varargin{:}, ...
            'ModelEditFcn', @gui_globalmodsetup);
    case 'layout'
        [m, ok] = gui_globalmodsetup(m.xregmulti, action, varargin{:}, ...
            'ModelEditFcn', @gui_globalmodsetup);
    case 'getclasslevel'
        m = mfilename('class');
end
