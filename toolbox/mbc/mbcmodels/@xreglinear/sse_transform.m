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
%   $Revision: 1.5.4.3 $  $Date: 2004/02/09 07:50:12 $



switch(transform)
case('boxcox')
   if length(varargin) == 0 | isempty(varargin{1})
      LambdaRange = -3:0.5:3;
   else
      LambdaRange = varargin{1};
   end
   
   sse_data=[];
   
   set(m,'fitalg','leastsq');
   % Loop through lambda, evaluating SSE at each value and store in SSE_DATA
   for l = LambdaRange;	
      set(m,'boxcox',{l,double(Y)});  			% define the BOXCOX Transform
      mf = fitmodel(m,X,Y);						% Perform a least squares model fit
      ss = mf.Store.mse;					% Extract the statistics from the mdel fit 
      sse_data = [sse_data ss];			% one of which is SSE
   end
   
	% Calculate the confidence interval, ci, 

	df=dferror(mf); 

   min_sse = min(sse_data);
   ci = min_sse*(1 + tinv(0.975,df)^2/df);	
   
	varargout{1} = sse_data;
   varargout{2} = ci;
   varargout{3} = LambdaRange;
end
