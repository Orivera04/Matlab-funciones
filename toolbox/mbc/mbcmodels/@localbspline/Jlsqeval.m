function y= Jlsqeval(bs,k,varargin);
%JLSQEVAL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:00 $


y= lsqresiduals(k,bs,varargin{:});