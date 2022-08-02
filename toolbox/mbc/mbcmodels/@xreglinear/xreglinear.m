function ml = xreglinear(c,Constant,varargin);
% xreglinear parent model class for all linear models
%
% ml = xreglinear(c,Constant);
% A linear model is defined a model which can be estimated using
% linear regression techniques.
% Presently xreglinear is used as a parent model class for polynom, xregcubic and 
% xreg3xspline. It can also be used in its own right for standard multivariable
% linear models.
%
% Inputs  c        coefficients  (column vector)
%         Constant Model contains a constant terms (0/1)
%
% Outputs ml       xreglinear object
%
% Parent Class     MODEL 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 07:50:25 $



if nargin==0
   c= [1:4]';
   Constant=1;
end
switch class(c)
case 'struct'
   ml=c;
   m = ml.xregmodel;
   ml= mv_rmfield(ml,'xregmodel');
case 'xreglinear'
   ml= c;
   return
case 'char'
   if strcmp(c,'nfactors')
      ml=xreglinear;
      ml.xregmodel= xregmodel('nfactors',Constant);
      return
   end 
otherwise
   % Temporary store for data to enable efficient calculation of statistics
   ml.Store   = [];
   % linear coefficients, as column vector
   ml.Beta    = c(:);
   % Terms exluded from model (used by stepwise)
   ml.TermsOut  = false(size(ml.Beta));
   % Model contains constant term
   ml.Constant= Constant;
   
	
   m= xregmodel; 
end

% Terms Status (1= Always in, 2= Never In, 3= TBD by stepwise) 
ml.TermStatus= 3*ones(size(ml.Beta));

% version
ml.version =3;

% new fields
ml.lambda = 0;
ml.qr  = 'ols';

ml= class(ml,'xreglinear',m);