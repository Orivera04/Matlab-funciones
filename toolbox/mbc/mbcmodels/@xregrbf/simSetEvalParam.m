function simSetEvalParam(m,sys)
%XREGRBF/SIMSETEVALPARAM Sets the simulink parameters required to evaluate
%an RBF model in simulink
%
%   SIMSETEVALPARAM(M,SYS) sets the parameters in the simulink system SYS
%   required to evaluate the RBF model M.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:57:21 $

vars = {'center','beta','width'};

% Need to remove terms which have been taken out by stepwise
termsIn = find( Terms( m ) );
center = m.centers(termsIn,:);
beta = double(m);
beta = beta(termsIn);
width = m.width;
if size( width, 1 ) > 1,
    width = width(termsIn,:);
end

% expand width to be the same size as centers
[mc,nc] = size( center );
[mw,nw] = size( width );
if mw == 1,
    width = repmat( width, mc, 1 );
end
if nw == 1,
    width = repmat( width, 1, nc );
end

% Centers
values{1} = center';
% Weights/coefficients/beta
values{2} = beta;
% Width
values{3} = width';

% extra stuff for wendland
if strcmp(func2str(m.kernel),'wendland')
	[e,p] = wendcoeff(m);
	values{4} = length(p);
	values{5} = e;
	values{6} = p;
	vars = {vars{:} 'WendlandNumTerms','exponent','polyTerms'};
end

AddVariablesToUserdata(sys,vars,values);

% -------------------------------------------------------------
function str = i_matrix2str(value)

str = ['['];
for i = 1:size( value, 1 )
	str = [ str sprintf('%.20g ',value(i,:)) ';'];
end
str = [ str ']'];

% EOF
