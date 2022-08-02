function [hs, cb]= surface( m, x, axh, varargin )
%XREGARX/SURFACE   Surface plot method for ARX models
%    [HS,CB] = SURFACE(M,X)
%    [HS,CB] = SURFACE(M,X,AXH,...)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:45:43 $


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
    'String', 'Sorry. Surface plots are unavaliable for ARX models' );

% outputs
hs = [];
cb = [];

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
