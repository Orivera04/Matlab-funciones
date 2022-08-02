function des=reorder(des,ord)
%REORDER Reorder design points
%
%   D=REORDER(D,ORD) reorders the design points in D  according to the
%   indices in ORD.  ORD must have the same number of unique indices as
%   there are in the design (and must not attempt to index outside of D) or
%   an error will occur.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:07:38 $

% Check ord
np = npoints(des);
ord(ord<1) = [];
ord(ord>np) = [];

ord2 = unique(ord(:))';
if length(ord2)~=np
   error('Invalid reordering specified.');
end

% reorder factor settings, index vector, fixed points

des.design = des.design(ord,:);
des.designpointflags = des.designpointflags(ord);
des.designindex = des.designindex(ord);
