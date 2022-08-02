function fig = findfigure(h)
% Get the figure for plot

%   Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2004/03/05 18:21:39 $

fig = getfigure(h);
if fig==-1; return; end;
if isempty(fig); fig = gcf; end;

% Update the setting
name = get(fig, 'Name');
if isempty(name) || ~ishold
    name = h.DataSource;
end
if isempty(name)
    set(fig, 'HandleVisibility', 'on');
else
    set(fig, 'NumberTitle','off', 'HandleVisibility', 'on', 'Name', name);
end