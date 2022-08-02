function varargout= forwardselect(m,varargin)
% XREGMULTILIN/FORWARDSELECT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:26 $

ind=get(m,'currentindex');
mdls=get(m,'models');
% despatch to appropriate contained model
[varargout{1:nargout}]= forwardselect(mdls{ind},varargin{:});

