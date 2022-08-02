function [risk,ror,wts] = frontier(asset,ret,pts,target) 
%FRONTIER Efficient frontier. 
%       [RISK,ROR,WTS] = FRONTIER(ASSET,RET,PTS,TARGET) returns
%       the standard deviations,RISK,and rates of return,ROR,that comprise the
%       efficient frontier of a given portfolio, plus the weights of each
%       asset,WTS,for each point on the frontier.  ASSET is an M-by-N matrix
%       of time series data where each column represents a
%       single asset.  RET is a 1-by-N vector of the rates of return for
%       asset.  PTS specifies the number of efficient frontier points to be
%       calculated.  By default, PTS = 10.  TARGET specifies the desired rate
%       of return based on the ASSET and RET data.  When entering a target
%       rate of return, enter PTS as an empty matrix.  RISK and ROR are
%       PTS-by-1 vectors, and WTS is a PTS-by-(number of assets) matrix. 
% 
%       FRONTIER(ASSET,RET) plots the efficient frontier without returning 
%       any data to the MATLAB workspace. 
%        
%       [RISK,ROR,WTS] = FRONTIER(ASSET,RET,PTS) returns the standard  
%       deviations, rates of return, and weights of each point on the  
%       efficient frontier. 
% 
%       [RISK,ROR,WTS] = FRONTIER(ASSET,RET,[],TARGET) returns the 
%       efficient frontier data associated with a specific rate of return 
%       on the frontier. 
% 
%       See also PORTRAND, PORTVAR, PORTROR. 
% 
%       Reference: Bodie, Kane, and Marcus, Investments, Chapter 7. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.9 $   $Date: 2002/04/14 21:47:14 $ 

%Set optimization scale option to turn off large-scale optimization.
OPTION = optimset('LargeScale', 'off', 'Display', 'off');

if nargin < 3 
  pts = 10; 
end 
if pts < 2 
  pts = 2; 
end 
if isempty(pts) 
  pts = 2; 
end 
if nargin < 2 
  error('Missing one of ASSET and RET.') 
end 
[m,n] = size(asset); 
[row,col] = size(ret); 
if n ~= col 
  error(sprintf('ASSET and RET must have equal number of columns.')) 
end 
if length(pts) ~= 1 
  error(sprintf('PTS must be a scalar value.')) 
end 
 
H = cov(asset); 
f = zeros(1,n); 
A(1,:) = ones(1,n); 
A(2,:) = -A(1,:); 
A(3:n+2,:) = -eye(n); 
b = [1;-1;f']; 
if nargin == 4 
  numtar = length(target(:)); 
  for j = 1:numtar 
    A(3+n,:) = ret; 
    A(4+n,:) = -ret; 
    b(3+n,1) = target(j); 
    b(4+n,1) = -target(j); 
    wts(j,1:n) = quadprog(H,f,A,b,[],[],[],[],[],OPTION)'; 
    risk(j) = sqrt(portvar(asset,wts(j,1:n))); 
    ror(j) = portror(ret,wts(j,1:n)); 
  end 
  return 
end 
 
wr1 = quadprog(H,f,A,b,[],[],[],[],[],OPTION)';           % Weights for global minimum 
r1 = portror(ret,wr1);        % Find minimum rate of return on frontier 
r2 = max(ret);                % Find maximum rate of return on frontier 
r = r1:(r2-r1)/(pts-1):r2;    % Generate rates of return on frontier 
k = 1;                        % Index used by for loop 
 
w = zeros(pts,n);             % Preallocate for loop matrix 
mv = zeros(max(size(r)),1);   % Preallocate for loop matrix 
for i = r                     % calculate weights for each rate of return 
  A(3+n,:) = ret; 
  A(4+n,:) = -ret;  
  b(3+n,1) = i; 
  b(4+n,1) = -i; 
  w(k,:) = quadprog(H,f,A,b,[],[],[],[],[],OPTION)'; 
  mv(k) = portvar(asset,w(k,:)); 
  k = k+1; 
end 
 
if abs(r1-r2) < 1e-6          % Compare difference in rates 
  v = portvar(asset,w);       % If difference is negligible, create one point    
  r = r1; 
else 
  v = sqrt(mv);               % Else calculate risk for each point 
end 
 
if nargout == 0 
  held = ishold;                % Get hold status of figure 
  % Plot efficient frontier and minimum risk point 
  plot(v,r,'c','linewidth',3,'erasemode','normal') 
  hold on 
  plot(min(v),max(r(find(v==min(v)))),'bo','linewidth',3,'erase','none') 
  if ~held 
    hold off                    % Turn hold off if necessary 
  end 
end 
if nargout ~= 0               % Return output 
  risk = v; 
  ror = r'; 
  i = find(abs(w)<1e-6); 
  w(i) = zeros(size(i)); 
  wts = w; 
end
