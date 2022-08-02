% gauss.m
% This example script plots the results of combining uniform random variables.
%
% Shows the advantage of setting the line data after the plt(..) call.
% Note the use of the 'FigName' and 'TraceID' arguments.
% Note the appearance of the greek letter in the x-axis label.

  mxN = 10;        % sum up to 10 uniform distributions
  sz = 100;        % size of each uniform distribution
  u = ones(1,sz);  % uniform distribution
  y = u;           % y will be composite distribution
  dis = [0 1 0 ones(1,mxN-3)]; % initially just show Gaussian and sum of 3 uniforms
  h = plt('TraceID',['Gauss'; reshape(sprintf('Sum%2d',2:mxN),5,mxN-1)'],...
           'LabelX','Standard deviation (\sigma)','LabelY','',...
           'COLORc','default','FigName','Sum of uniform distribtions',...
           'DIStrace',dis,'xlim',[-4 4],'ylim',[-.05 1.05],...
            0,1, 0,1, 0,1, 0,1, 0,1, 0,1, 0,1, 0,1, 0,1, 0,1);
  for n = 2:length(h)
    y = conv(y,u);  % convolve with next uniform distribution
    m = length(y);  mean = (m+1)/2;   sigma = sz * sqrt(n/12);
    x = ((1:m) - mean) / sigma; % change units to sigma (zero mean)
    set(h(n),'x',x,'y',y/max(y));
  end;
  set(h(1),'x',x,'y',exp(-(x.^2)/2)); % gaussian distribution

