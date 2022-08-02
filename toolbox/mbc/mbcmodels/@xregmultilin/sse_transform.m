function varargout = sse_transform(m,transform,X,Y,varargin)
% xreglinear/sse
%  [sse,ci,TransformOutputs] = sse_transform(model,transform,X,Y,TransformParameters)
%  Computes the sse and confidence interval on data X and Y given transformation
%  transform
%
%	For transform = 'boxcox' an optional TransformParameter Lambda_Range allows the sse
%	to be computed over a vector of possible lambda. If Lambda_Range is not included it
%	defaults to -3:0.5:3. Lambda_Range is returned in the TransformOutputs

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:58 $
varargout = cell(1,nargout);
[varargout{:}] = sse_transform(get(m,'currentmodel'),transform,X,Y,varargin{:});