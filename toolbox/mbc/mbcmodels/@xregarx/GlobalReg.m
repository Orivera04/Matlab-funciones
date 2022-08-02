function varargout = GlobalReg( m, action, varargin )
%XREGARX/GLOBALREG  GLOBALREG method for XREGARX
%    GLOBALREG(M,ACTION,...)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:44:42 $

switch lower( action ),
case 'create'
   varargout{1} = i_create( varargin{:}, m );
case 'update'
   i_updatemodel;
case 'view'
   i_View( varargin{:} );
case 'show'
   varargout{1} = i_show( varargin{:} );
case 'hide'
   i_hide( varargin{:} );
case 'subfigure'
   varargout{1}= i_subfigure( varargin{:} );
case 'globalmenus'
   % model dpt menus
   varargout{1}= [];
end

return

%------------------------------------------------------------------------------|
function View = i_create( fParent, TabObj, View,m );
return


%------------------------------------------------------------------------------|
function View = i_show( hFig, View, p );
return

%------------------------------------------------------------------------------|
function i_View( hFig, View, p );
return


%------------------------------------------------------------------------------|
function i_hide( hFig, View, p );
return

%------------------------------------------------------------------------------|
function chH = i_subfigure( Action, figh, p );

if nargin<2
   figh = gcbf;
   p = get( MBrowser, 'CurrentNode' );
end

chH = [];
switch lower(Action)
case 'transform'
   msgbox (sprintf( 'Y-Trans not available for %s models.', class( p.model) ),...
      'Y-Transform' );
   return
   
case 'fitmodel'
   p.fitmodel;
   ViewNode( MBrowser );
   return
   
case 'fitopts'
   [m, ok] = gui_globalmodsetup( p.model );
   if ok,
      p.model( m );
   end
   return
   
otherwise,
    pp = xregpointer( get( p.model, 'StaticModel' ) );
    cbh = GlobalReg( pp.info, 'SubFigure', Action, figh, pp );
    free( pp );
    return
   
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

