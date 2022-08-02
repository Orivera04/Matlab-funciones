function simSetEvalParam(m,sys)
%XREGLOLIMOT\SIMSETEVALPARAM

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.2 $  $Date: 2004/02/09 07:50:53 $

vars = {'polycoeff','center','width'};

% Create the centers matrix in a text format
center = get(m, 'centers')';
beta = double(m);
width = get(m, 'width')';
nC = get(m, 'numberofcenters');
nR = length(beta)/nC;

values{1} = reshape(beta, [nR nC]);
values{2} = center;
values{3} = width;

kernel = get( m, 'Kernel' );
if strcmp( kernel,'wendland')
	[e,p] = wendcoeff(m);
	values{4} = length(p);
	values{5} = e;
	values{6} = p;
	vars = {vars{:} 'WendlandNumTerms','exponent','polyTerms'};
end

AddVariablesToUserdata(sys,vars,values);

% Ensure that the correct stuff for the cubic evaluation is set up
simSetEvalParam(m.betamodels{1}, sys);
