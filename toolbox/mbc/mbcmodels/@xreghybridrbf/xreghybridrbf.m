function  m = xreghybridrbf(varargin)
% POLYRBF hybrid xreglinear/radial basis function object constructor a child of xreglinear
%
%   fields: m.linearmodpart     - field for the xreglinear part e.g. polynomial
%           m.rbfpart           - field for the radial basis function
%           m.chosenorder       - field to store the order in which the terms were chosen
%           m.lambda            - field to store regularisation parameters
%           m.om (temporary field for the xregoptmgr until this is stored at the model level)
            

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:48:34 $




if nargin & ischar(varargin{1})
   switch lower(varargin{1})
   case 'nfactors'
      nf= varargin{2};
   otherwise 
      nf =1;
   end 
else
   nf=1;
end 
lm = xreglinear('nfactors',nf);
polydegree = floor((nf+2)/2) - 1; 
m.linearmodpart = xregcubic(polydegree*ones(1,nf),get(lm,'symbol'));%field for storing a linear part 
m.rbfpart = xregrbf('nfactors',nf);%field to store the rbf
m.chosenorder = [1:size(m.linearmodpart,1) + size(m.rbfpart,1)];
m.om = []; %field to store xregoptmgr
                               
beta = [double(m.linearmodpart);double(m.rbfpart)];
lm = update(lm,beta);
m = class(m,'xreghybridrbf',lm);%create the hybrid rbf as a child of xreglinear.
set(m,'fitalg','hybridrbffit');% default fit algorithm
[om,OK] = widthstep(m);
setFitOpt(m,om);
return

