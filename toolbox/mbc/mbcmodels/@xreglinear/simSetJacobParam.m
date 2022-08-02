function simSetJacobParam(m,sys)
% xreglinear/SIMSETJACOBPARAM - set parameters needed for Jacobian Estimation in Simulink

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:50:09 $

% need to set the following:
% 1) R
% 2) S0
% 3) S1
% 4) nterms
% 5) termsout


% R
R = var(m);

% S1 
S1= size(R);

% nterms
nterms= length(double(m));

% termsout
termsout=find(Terms(m));

% S0
S0= size(termsout');

% add all these to a mask - Note that R, s0 and s1 might
% get set later by twostage/modelbuild so keep as mask variables
vars = {'R','s0','s1'};
values = cell(3, 1);
values{1} = 'R'; % this will be set later.
values{2} = ['[' num2str(S0) ']'];
values{3} = ['[' num2str(S1) ']'];
AddVariablesToMask(sys,vars,values);

vars = {'numterms','termsout'};
values = cell(2, 1);
values{1} = nterms;
values{2} = termsout';
AddVariablesToUserdata(sys,vars,values);
