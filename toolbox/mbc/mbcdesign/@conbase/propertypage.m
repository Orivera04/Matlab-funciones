function [out, out2] = propertypage( obj, action, varargin )
%PROPERTYPAGE   Generate an editing page for constraint objects
%  LYT = PROPERTYPAGE(OBJ,'CREATE',FIG,PTR,MDL,FACTORS)
%  [OK,MSG] = PROPERTYPAGE(OBJ,'FINALISE',LYT)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:57:13 $ 

switch lower(action)
    case 'create'
        out = i_createlyt( varargin{:} );
        out2 = [];
    case 'finalise'
        [out, out2] = i_finalise( varargin{:} );
end

return

% -------------------------------------------------------------------------|
function lyt = i_createlyt( fig, ptr, varargin )

msg = sprintf( '%s constraint are not editable in this way.', ...
    upper( typename( ptr.info ) ) );

txt = xreguicontrol(...
    'parent', fig,...
    'hittest', 'off',...
    'enable', 'inactive',...
    'style', 'text',...
    'string', msg,...
    'horizontalalignment', 'center');

lyt = xreggridlayout( fig, ...
    'dimension', [1 2],...
    'rowsizes', [-1],...
    'ColRatios', [1, 2],...
    'gapx',7,...
    'elements',{ [], txt } );

return

% -------------------------------------------------------------------------|
function [ok, msg] = i_finalise( lyt )

ok = true;
msg = {};

return

% --------------------------------------------------------------------
% EOF
