function obj = prepend(obj, newobj)
% DESIGNDEV/PREPEND prepends a designdev object to an object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:18 $

obj = append(newobj, obj);