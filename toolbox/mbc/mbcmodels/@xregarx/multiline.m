function h = multiline( m, x, axh, varargin )
%XREGARX/MULTILINE   Contour plot method for ARX models
%    H = MULTILINE(M,X)
%    H = MULTILINE(M,X,AXH,...)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:44:59 $

if nargin < 3,
   axh = gca;
end

% make the axes in visible
set( axh, 'Visible', 'off' );, ...

% display a little message
text( 'Parent', axh, ...
    'Units', 'Normalized', ...
    'Position', [0.5, 0.5], ...
    'HorizontalAlignment', 'Center', ...
    'VerticalAlignment', 'Middle', ...
    'FontWeight', 'Bold', ...
    'String', 'Sorry. Multiline plots are unavaliable for ARX models' );

% outputs
h = [];

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
