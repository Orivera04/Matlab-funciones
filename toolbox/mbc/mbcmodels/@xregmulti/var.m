function varargout= var(m,varargin);
% MULTIMODEL/VAR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:54:12 $

% get var info from currently selected model
mi= m.models{m.currentindex};
[varargout{1:nargout}]= var(mi,varargin{:});