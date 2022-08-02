function m= xreg3xspline(varargin);
% xreg3xspline multivariable hybrid spline/cubic constructor
%
% m= xreg3xspline(spline_order,knots,mv3,Interact,SplineVar,Label);
% 
% Inputs                                                  Defaults
%   spline_order   order of spline order                  3
%   knots          knots for spline (must be (-1,1))      0
%   mv3            xregcubic object representing cubic      xregcubic([3 3 2],{'L','A','E'})
%                  (non-spline) terms                                   
%   Interact       level of interaction between spline    1
%                  and cubic terms. Interactions of 
%                  higher order are defined using raw
%                  spline variable (e.g. L^2*N instead of
%                  L^2*PHI
%   SplineVar      Index to spline variable               1           
%   Label          Label for Spline Variable              'N'
%
% Parents          xreglinear
%                  MODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 07:44:27 $



LoadObj=0;
if nargin==1 & isa(varargin{1},'struct');
   % Old structure from xreg3xspline/LOADOBJ
   LoadObj=1;
	
	[m,mlin]= i_Update(varargin{1});
	
   
elseif nargin & ischar(varargin{1})
   % 'nfactors',N interface
   switch lower(varargin{1})
   case 'nfactors'
      Defaults= {3,0,xregcubic('nfactors',varargin{2}-1),1,1,'N'};
      m=xreg3xspline(Defaults{:});
      return      
   end  
else
   
   
   % Set up defaults
   Defaults= {3,0,xregcubic([3 3 2],{'L','A','E'}'),1,1,'N'};
   Defaults(1:nargin)= varargin;
   [poly_order,knots,mv3,Interact,SplineVar,Label] = deal(Defaults{:});
   
   Ns= length(knots) + poly_order + 1;
   m.knots = knots;
   m.poly_order = poly_order;
   m.cubic =  mv3;
   m.interact = Interact;
   
   m.splinevar = SplineVar;
   
   % Sorted Order of xregcubic
   N= order(mv3);
   
   % Standard Nested loop structure for xreg3xspline
   % This loop determines number of terms in this model.
   
   % PHI Terms
   len= Ns;
   for i=1:N(1)
      if Interact>=1
         % Xi * PHI terms
         len = len + Ns;
      else
         % Xi * [1 X1 X1^2] terms 
         len=len+3;
      end
      for j=i:N(2)
         if Interact>=2
            % Xi * Xj * PHI terms
            len = len + Ns;
         else
            % Xi * Xj * [1 X1] terms 
            len=len+2;
         end
         for k=j:N(3)
            % Xi * Xj * Xk  terms 
            len=len+1;
         end
      end
   end
   
   % Set up parent xreglinear
   mlin= xreglinear([1:len]',0);
   set(mlin,'nfactors',nfactors(m.cubic)+1);
   s3= get(m.cubic,'symbol');
   s3=s3(:);
   i=m.splinevar ;
   % insert spline variable in correct position
   labels = [s3(1:i-1) ;  {Label} ; s3(i:end)];
   xi= xinfo(mlin);
   if isempty(xi)
      % dependent factor info
      xi= struct('Names',{labels},...
         'Units','',...
         'Symbols',{labels});      
   else
      xi.Names= labels;
      xi.Symbols= labels;
   end
   mlin= xinfo(mlin,xi);
end


o3= reorder(m.cubic);
i=m.splinevar ;
o3(o3>=i)= o3(o3>=i)+1;
% insert spline variable in correct position
m.reorder = [i o3];

m.version=4;
m= class(m,'xreg3xspline',mlin);
if ~LoadObj;
   m= setstatus(m,1:Ns,1);
end


function [m,mlin]= i_Update(m)

s3= get(m.cubic,'symbol');
i=m.splinevar ;
s3= s3(:);
% insert spline variable in correct position
labels = [s3(1:i-1) ;  {m.label} ; s3(i:end)];

% Set up parent xreglinear
mlin= xreglinear(m.xreglinear);
xi= xinfo(mlin);
if isempty(xi)
	% dependent factor info
	xi= struct('Names',{labels},...
		'Units','',...
		'Symbols',{labels});      
else
	xi.Names= labels;
	xi.Symbols= labels;
end
mlin= xinfo(mlin,xi);   

m=mv_rmfield(m,'xreglinear');
m=mv_rmfield(m,'label');

% xreg3xspline version
if isfield(m,'version');
	m=mv_rmfield(m,'version');
end
