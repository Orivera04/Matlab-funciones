function [y,varargout]=EvalModel(TS,x,varargin);
% TWOSTAGE/EVALMODEL evalutate model (with coding and yinv)
% 
% [y,varargout]=EvalModel(m,x,varargin);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:10 $


% X could be a sweepset 
% X Transformation

% don't make double here
if isa(x,'cell')
	nl= nfactors(TS.Local);
	if isa(x{1},'sweepset')
		x{1}(:,1:nl)= code(TS,double(x{1}),1:nl);
	else
		x{1}= code(TS,double(x{1}),1:nl);
	end

	if isa(x{2},'sweepset')
		x{2}(:,1:size(x{2},2))= code(TS,double(x{2}),nl+1:nfactors(TS));
	else
		x{2}= code(TS,double(x{2}),nl+1:nfactors(TS));
	end
	
else
	x(:,1:size(x,2)) = code(TS,double(x));
end

for i=1:length(varargin)
   varargin{i}= double( varargin{i} );
end
% Evalation (polymorphic method)
if nargout>1
   [y,varargout{1:nargout-1}] = eval(TS,x,varargin{:});
else
   y= eval(TS,x,varargin{:});
end
if ~isTBS(TS)
   % invert any y transformation
   y = yinv(TS,y);
end

if ~isreal(y)
	y(abs(imag(y))>eps)= NaN;
	y =real(y);
end