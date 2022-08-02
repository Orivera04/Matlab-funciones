% subdiv2.m
% subdivide a vector

x=[4 5 7 6]; % test data
n=4;         % number of subdivisions

N=length(x); % length of data

xx=repmat(x(1:end-1),n,1);   % replicate x
ff=repmat((0:n-1)'/n,1,N-1); % replicate normalized spacing
ddx=repmat(diff(x),n,1);     % replicate differences in x
y=xx+ff.*ddx;                % compute results
y=[y(:)' x(end)];            % back to 1-D