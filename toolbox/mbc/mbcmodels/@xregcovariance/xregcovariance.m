function c= covmodel(w,corr);
% COVMODEL covariance model constructor

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:46:35 $


if nargin==0
   w='';
   corr='';
end

if nargin== 1 & isa(w,'struct')
   c= w;
   loadcov=1;
else
   loadcov=0;
   c.wfunc= w;
   c.cfunc= corr;
   
   c.wparam=[];
   c.cparam=[];
   
   c.costFunc= 'costW_REML';
   c.fitOptions= 'glsW';
end

c.Ts= 0;

c= class(c,'xregcovariance');

if ~loadcov & ~isempty(c.wfunc);
   nw= feval(c.wfunc,c);
   c.wparam= zeros(nw,1);
end
