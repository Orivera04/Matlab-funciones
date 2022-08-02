function ch= char(L,varargin);
%LOCALMULTI/CHAR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:39:49 $

m= get(L.xregmulti,'currentmodel');
ch= char(m,varargin{:});
