function varargout = setsplitable( Tree, panel, state )
%XREGFITTREE/SETSPLITABLE Set the splitable state of the a panel
%  SETSPLITABLE(T,PANEL,STATE) sets the splitable state, either true or false, 
%  of the given PANEL. 
%
%  See also XREGFITTREE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 

if any( Tree.Children(panel,:) ~= 0 ),
    warning( 'PANEL has already been split' );
end

Tree.Splitable(panel) = logical( state );

if nargout == 1,
    varargout{1} = Tree;
elseif isvarname( inputname(1) ),
    assignin( 'caller', inputname(1), Tree );
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
