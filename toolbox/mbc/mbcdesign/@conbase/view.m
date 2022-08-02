function out = view( C, action, varargin )
%VIEW  Throws up a window with a description of the constraint object
%   VIEW(C) returns a handle to the window. This can also be achieved with 
%   VIEW(C,'Figure').
%   To get the text in a given axes, use VIEW(C,'InAxes',AXH) where AXH is the 
%   handle for the axes object. A vector with the overall hieght and width of 
%   the text objects will be returned.
%   VIEW(C,'..',SYMBOLS) uses the symbols in the cell array symbols rather
%   than the defualt of {'X1', 'X2', ... } to display the description of
%   the constraint.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.6.1 $    $Date: 2004/02/09 06:57:24 $ 

if nargin < 2,
    action = 'Figure';
end

switch lower( action ),
case 'figure',
    out = i_createfig( C, varargin{:} );
case 'inaxes',
    [out(1),out(2)] = i_createtext( C, varargin{:} );
otherwise
    out = [];
end

return

%---------------------------------|--------------------------------------------|
function figh = i_createfig( C, varargin )

figh = i_lookforhandle;
if isempty( figh ),
    figh = xregfigure(...
        'Tag', i_hash_fig_tag,...
        'Name', 'Constraint Description',...
        'Visible', 'off',...
        'Resize', 'off' );
    figh = double(figh);
    
    axh = xregaxes( ...
        'Parent', figh,...
        'Units','pixels',...
        'Visible','off' );
    xregframe3dlayout( figh, 'Center', axh );
    set( figh, 'UserData', axh );
else
    axh = get( figh, 'UserData' );
    delete( get( axh, 'Child' ) );
    if isempty( axh ),
        axh = xregaxes( ...
            'Parent', figh,...
            'Units','pixels',...
            'Visible','off' );
        
    end
end

[H,W] = i_createtext( C, axh, varargin{:} );

% Resize Figure
pos = get( figh,'position');
pos(4) = H + 30;
pos(3) = W + 40;

set( axh,  'position', [10 25 pos(3:4)-[20 20]] );
set( figh, 'position', pos );

set( figh, 'visible', 'on' )

return

%---------------------------------|--------------------------------------------|
function [H,W] = i_createtext( C, axh, symbols )

if nargin < 3,
    % generate factor names
    nf = getsize( C ); % number of factors
    symbols = cell( 1, nf );
    for i = 1:nf,
        symbols{i} = sprintf( 'X%d', i );
    end
end
txt = tostring( C, symbols );

% 
str = [ {['Contraint type: ' typename(C)]};...
        cellstr(txt)];   
bold = [ 1; zeros(size(txt,1),1) ];
indent = [ 0; ones(size(txt,1),1) ];

[H,W] = xregtextlist( axh, [0 0 0], str, indent, bold, 7, 15 );

return

%---------------------------------|--------------------------------------------|
function H = i_lookforhandle
H = findobj( allchild(0), 'flat', 'tag', i_hash_fig_tag );
return

%---------------------------------|--------------------------------------------|
function s = i_hash_fig_tag
s = 'ConmodelFigure';
return

%---------------------------------|--------------------------------------------|
% EOF
%---------------------------------|--------------------------------------------|
