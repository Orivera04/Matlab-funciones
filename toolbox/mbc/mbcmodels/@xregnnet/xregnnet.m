function nn = xregnnet(varargin)
% XREGNNET Neural network object constructor

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 07:56:36 $

% Parent    NONLINMOD  
%           MODEL


% check that neural net models are available
persistent gotlicense
if isempty(gotlicense) | ~gotlicense
   % try to get license
   gotlicense=mbcchecklicenses(3);
end

if ~gotlicense
   error('A license could not be obtained for the Neural Networks Toolbox.');
end

nn.version = 2; %version number

if nargin == 1
   nn.param = varargin{1};
   m=xregmodel('nfactors',varargin{1}.numInputs);
elseif nargin & ischar(varargin{1})
   % nfactors interface
   switch lower(varargin{1})
   case 'nfactors'
      nn.param=newff(repmat([-1 1],varargin{2},1),[10 5 1],{'tansig' 'tansig' 'purelin'},'trainbr');
      nn.param=i_setdefaults(nn.param);
      m=xregmodel('nfactors',varargin{2});
   end
else  
   nn.param = newff(repmat([-1 1],4,1),[10 5 1],{'tansig' 'tansig' 'purelin'},'trainbr');
   nn.param=i_setdefaults(nn.param);
   m=xregmodel('nfactors',4);
end

nn = class(nn,'xregnnet',m);
return




function nn=i_setdefaults(nn)

nn.trainparam.lr=.01;
nn.trainparam.mc=.9;
nn.trainparam.mu=.005;
nn.trainparam.mu_dec=.2;
nn.trainparam.mu_inc=3;
nn.trainparam.epochs=500;
nn.trainParam.goal = 0.0001;			%sum-squared error goal
nn.trainParam.min_grad = 0.0001;	%initial adaptive learning rate
nn.trainParam.show = 50;				%display frequency

nn= init(nn);

return