function U= xregusermod(varargin);
%XREGUSERMOD Constructor for user-defined model
%
%  MDL = XREGUSERMOD('name',NM) creates a user-defined model object, MDL,
%  with the name NM.
%
%  Example usage:
%
%    m = xregusermod('name','weibul');
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.3 $  $Date: 2004/02/09 08:01:47 $

if nargin==1 & isa(varargin{1},'xregusermod')
   U = varargin{1};
   return
end

funcName= 'functemplate';
nf=1;
n= 2;
if nargin>=2
   for i=1:2:nargin-1
      switch lower(varargin{i})
      case {'funcname','name'}
         funcName = varargin{i+1};
      case 'nfactors'      
         nf= varargin{i+1};
         [list, f] = getmodellist(xregusermod, nf);
         if isempty(list)
             error('No user defined models available for %d factors.\n', nf);
         else
             funcName = list{1};
         end
      end %%switch
   end %% loop for each pair of argin
end


if ischar(funcName)
    funcName= str2func(funcName);
end
U.funcName= funcName;
U.parameters= zeros(n,1);

U.fitOpts= [];

m= xregmodel('nfactors',nf);
U= class(U,'xregusermod',m);
if ~strcmp(name(U),'functemplate')
    U = funcinit(U,name(U));
end
