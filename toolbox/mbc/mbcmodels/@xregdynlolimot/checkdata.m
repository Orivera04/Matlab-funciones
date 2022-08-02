function [X,y,varargout]= checkdata(m,X,y,varargin);
% MODEL/CHECKDATA transforms and checks data prior to fitting
%
% [x,y,DataOK]= checkdata(m,x,y);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:45:52 $

x=double(X);
y=double(y);

% Perform Y Transformation
y = ytrans(m,y);
% Perform X Coding Transformation
x = code(m,x);

if ~isequal(size(x,1),size(y,1))
    error('X and Y vectors must be the same size.')
end
DataOK= isfinite(y) & all(isfinite(x),2);
% remove complex data if introduced by transformations
if ~isreal(y) | ~isreal(x);
   TolC= 1e-8;
   rdata = abs(imag(y))<TolC & all(abs(imag(x)<TolC),2); 
   y= real(y);
   x= real(x);
   DataOK = DataOK & rdata;
end

if isa(X,'sweepset') & size(x,3)~=size(x,1)
   X=X(DataOK,:);
   X(:,:)= x(DataOK,:);
else
   X= x(DataOK,:);
end
y=y(DataOK);
if nargin>3
	varargout= [varargin {DataOK}];
else
	varargout{1}= DataOK;
end
	
