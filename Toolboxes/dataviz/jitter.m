function data = jitter(data,scale)
%  calculate jittered values of data
%  data = jitter(data,scale)
%  use a uniform random distribution between +- scale
%  the default scale is 0.33
%  jitter is used to separate overlying plot points

% Copyright (c) 1998-2000 by Datatool
% $Revision: 1.10 $

if nargin<2
   scale = 0.33;
end

data = data+scale*rand(size(data))-scale/2;
