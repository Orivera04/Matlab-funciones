function [br] = setfriend( br, fm )
%SETFRIEND Set the friend model for a root node
%
%  BR = SETFRIEND(BR,FM)
%  
%  If present, the friend model controls the coding of data for the GETDATA
%  method.
%
%  See also: XREGBDRYROOT/GETDATA.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:13:42 $ 

br.Friend = fm;
xregpointer( br );
