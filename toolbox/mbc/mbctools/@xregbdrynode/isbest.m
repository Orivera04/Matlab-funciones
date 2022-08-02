function [out] = isbest(bdev)
%ISBEST True for best constraints (nodes in boundary model trees)
%
%  ISBEST(B) returns 1 if B is a best node in its boundary constraint model
%  tree.
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:13:17 $ 

parent = Parent( bdev );
if isempty( parent ),
    out = false;
else
    out = any( getbest( info( parent ) ) == address( bdev ) );
end
