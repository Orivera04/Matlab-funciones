function  m = xregrbf(varargin)
% XREGRBF radial basis function object constructor. 
% XREGRBF is a child of xreglinear
%
%   fields:
%           m.centers - the positions of the centers [c_1; c_2; ...; c_ncenters]					
%                        where each c_i is a vector of nfactor elements 
%	        m.width   - the width of the radial basis function
%           m.lambda  - the regularization parameter
%           m.kernel  - type of radial basis function
%           m.cont    - continuity for Wendland's functions
%           

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 07:57:39 $

if nargin ==1 & isa(varargin{1},'struct')
	% lpadobj 
	[m,ml]= i_Update(varargin{1});
	
else
	if nargin & ischar(varargin{1})
		% 'nfactors',N interface
		switch lower(varargin{1})
		case 'nfactors'
			nf= varargin{2};
			m = i_setdefaults([],nf);
		otherwise 
			nf =1;
			m=i_setdefaults([],nf);
		end 
	else
		nf=1;
		m=i_setdefaults([],nf);
	end 
	lm = xreglinear('nfactors',nf);
	set(lm,'lambda',1e-4);
	m = class(m,'xregrbf',lm);%create a radial basis function model to be a child of a xreglinear.
	set(m,'fitalg','rbffit');
	[om,OK] = widthstep(m);
	m.om =om; 
end
return

function m=i_setdefaults(m,nf);

m.centers = rand(4,nf);% default 4 centers
m.width = 2;
m.kernel =@multiquadric;
m.cont = 4;
m.om = []; %temporary field to store xregoptmgr
return


function [m,lm]= i_Update(m);

lm= xreglinear(m.xreglinear); 
set(lm,'lambda',m.lambda)
r= struct('centers',m.centers,...
	'width',m.width,...
	'kernel',m.kernel,...
	'cont',m.cont,...
	'om',[]);
r = class(r,'xregrbf',lm);%create a radial basis function model to be a child of a xreglinear.
if ~isfield(m,'om')
	r.om= trialwidths(r);
	set(r,'fitalg','rbffit');
end
m= r;

                               