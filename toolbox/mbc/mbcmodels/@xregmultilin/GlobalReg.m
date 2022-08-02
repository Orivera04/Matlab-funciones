function varargout= GlobalReg(m,Action,varargin)
% xreglinear/GLOBALREG model browser display for xreglinear global and one-stage regression
%
% varargout= GlobalReg(m,Action,varargin)
%   where m isa xreglinear

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:03 $
varargout= cell(1,nargout);
[varargout{:}]= GlobalReg(get(m,'currentmodel'),Action,varargin{:});