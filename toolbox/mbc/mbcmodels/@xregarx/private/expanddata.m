function xx = expanddata( x, y, order, delay )
%EXPANDDATA   Dynamic to static data conversion
%   EXPANDDATA(X,Y,ORDER,DELAY) takes the input data X and response data Y for 
%   a dynamic model with dynamic order ORDER and delay DELAY and produces data 
%   suitable for input into the static part of a series-parallel dynamic model.
%
%   An input X gets expanded to X(K-Q), X(K-P-1), ..., X(K-Q-P+1), where Q is 
%   the delay and P the dyanmic order for that variable. Note that X 
%   contributes P terms.
%
%   See also EXPANDXINFO.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:45:30 $

error( nargchk( 4, 4, nargin ) );

if isa(x,'sweepset') & any(order) & size(x,3)~=size(x,1);
   Ns= size(x,3);
   % make sweepset
   ni= sum(order);
   n= reshape( strrep(sprintf('X%3d',1:ni),' ','0'),4,ni)';
   st.varNames= cellstr(reshape(n,4,ni)');
   st.data= zeros(size(x,1),ni);
   xx= [x(:,~1) struct2sweepset(x,st)];
   xss= cell(Ns,1);
   for i=1:size(x,3)
      % expand data test by test
      xss{i}= i_expanddata( x{i}, y(sindex(x,i)), order, delay );
   end
   % convert cell array to sweepset
   xx= cell2sweeps(xx,xss);
else
   xx = i_expanddata( double(x) , y, order, delay );
end
   




function xx = i_expanddata( x, y, order, delay )

% if the dynamic order is all zeros, then nothing to do
if ~any( order ), 
    xx = x;
    yy = y;
    return
end

% set the delay to zero where the order is zero
delay(order==0) = 0;

% get parameter values
nf = size( x, 2 );          % number of input factors
ni = sum( order );          % number of inputs to static model
mo = max( order + delay );  % maxmium order
np = size( x, 1 );          % number of points

% allocate space for output data
xx = zeros( np, ni );

%
z = 1; 
for i = 1:nf,
    ind = [ ones( 1, delay(i) ), 1:np-delay(i) ]';
    for j = 1:order(i),
        xx(:,z) = x(ind,i);
        z = z + 1; 
        ind = [ 1; ind(1:end-1) ];
    end
end
ind = [ ones( 1, delay(end) ), 1:np-delay(end) ];
for j = 1:order(end),
    xx(:,z) = y(ind);
    z = z + 1; 
    ind = [ 1, ind(1:end-1) ];
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
