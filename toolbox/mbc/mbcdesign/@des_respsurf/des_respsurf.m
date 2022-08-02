function rsd=des_respsurf(varargin)
% DES_RESPSURF   Constructor function
%   DES_RESPSURF returns a response surface design
%   object.  This has a design object as parent, one
%   of which may be input as the first argument.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:03:29 $

% Create 28/10/99

if nargin & isstruct(varargin{1})
   rsd=varargin{1};
   varargin(1)=[];
else   
   % Design optimising values
   % augmentation settings
   rsd.p=50;
   rsd.augmentmethod='random';    % random or optimal.  Optimal will be slow.
   
   % deletion settings (p is same as for augmentation)
   rsd.deletemethod='optimal';     % support random for a laugh?
   
   % Stopping criteria
   % The tolerance below which we call the iteration 'useless'
   rsd.delta=0.0001;
   % Maximum excursion iterations
   rsd.maxiter=2000;
   % Maximum number of useless iterations to tolerate
   % before we storm out in disgust
   rsd.q=250;
   % counter for q
   rsd.qnow=0;
   rsd.iternow=0;
   
   % optimisation flags
   rsd.optimisedon.cand=-1;
   rsd.optimisedon.design=-1;
   rsd.optimisedon.model=-1;
   
   rsd.preferredoptimiser='v-optimal';
end
rsd.version=1.2;

% sort structure fields so they're in the same order however they were created
c=struct2cell(rsd);
f=fieldnames(rsd);
[f,i]=sort(f);
c=c(i);
rsd=cell2struct(c,f,1);

if nargin & isa(varargin{1},'xregdesign')
   des=varargin{1};
else   
   des=xregdesign(varargin{:});
end

rsd=class(rsd,'des_respsurf',des);

return


