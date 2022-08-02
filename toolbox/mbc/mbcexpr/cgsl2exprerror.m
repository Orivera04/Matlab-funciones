function cgsl2exprerror( msg, bh )
%CGSL2EXPRERROR Error routine for cage simulink parsing
%
%  CGSL2EXPRERROR( ERRORMSG, BLOCKHANDLE )
%
% This is expected to be called by the cgparse* and cgsl2expr* functions
% It does some interesting stuff (shows the block that caused the problen
% etc) and then throws an error with the ID mbc:cgsl2expr:XXXXX

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 07:17:37 $

if nargin==2
    hilite_system( bh );
end

uiwait( xregerror( 'Error while importing strategy', msg ) );

if nargin==2
    hilite_system( bh, 'none' );
end

error( 'mbc:cgsl2expr:ParseError', msg );