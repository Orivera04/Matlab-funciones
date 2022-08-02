function [nl,f]= findnl(m,dG)
% LOCALUSERMOD/FINDNL - this returns the index to the nonlinear parameters for SIMULINK reconstruction
%
% [nl,f]= findnl(m,dG)
%  Inputs 
%    m     model
%    dG    delg/delp matrix jacobian matrix for response features (wrt model parameters)
%  Outputs
%    nl    parameters which cannot be reconstructed as linear functions of response features
%    f     indices to response features which are non linear functions of parameters

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:43:47 $

rfuser= get(m,'feat.index');
np= numParams(m);

% all user-defined response features are treated as nonlinear
f= find(rfuser>np);

if ~isempty(f)
	% nonlinear parameters are those who are not used as 
	% response features
	nl= setdiff(1:np,rfuser(rfuser<=np));
else
	nl = [];
end

