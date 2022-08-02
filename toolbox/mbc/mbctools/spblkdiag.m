function S= spblkdiag(varargin)
%SPBLKDIAG

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:20:54 $

if nargin == 1 & ndims(varargin{1})==3;
   varargin= num2cell(varargin{1},1:2);
end

S= mxblkdiags(varargin{:});
