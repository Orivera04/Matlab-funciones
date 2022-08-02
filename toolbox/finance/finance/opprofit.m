function p = opprofit(so,x,cost,flag,type)
%OPPROFIT Option profit.
%   P = OPPROFIT(SO,X,COST,FLAG,TYPE) returns the profit of an option given
%   the asset price, SO, strike price, X, and cost of the option, COST.
%   FLAG specifies if option is long (FLAG = 0) or short (FLAG = 1).  
%   TYPE determines whether the option is a call (TYPE = 0) or a put 
%   (TYPE = 1).
% 
%   For example, buying (long) a call option with a strike price $90 on an
%   underlying asset with a current price of $100 for a price of $4 returns 
%   a profit of $6 if the option is exercised under these conditions.
%
%   See also BINPRICE, BLSPRICE.

%       Author(s): C.F. Garvin, 2-23-95
%       Copyright 1995-2002 The MathWorks, Inc. 
%       $Revision: 1.6 $   $Date: 2002/04/14 21:56:56 $

if nargin < 5
  error('Missing one of SO, X, COST, FLAG, and TYPE.')
end
if any(any(flag ~= 0 & flag ~= 1)) 
  error(sprintf('FLAG must be 0 (long) or 1 (short).'))
end
if any(any(type ~= 0 & type ~= 1)) 
  error(sprintf('TYPE must be 0 (call) or 1 (put).'))
end
sz = [size(so);size(x);size(cost);size(flag);size(type)];
if length(so) == 1
  so = so*ones(max(sz(:,1)),max(sz(:,2)));
end
if length(x) == 1
  x = x*ones(max(sz(:,1)),max(sz(:,2)));
end
if length(cost) == 1
  cost = cost*ones(max(sz(:,1)),max(sz(:,2)));
end
if length(flag) == 1
  flag = flag*ones(max(sz(:,1)),max(sz(:,2)));
end
if length(type) == 1
  type = type*ones(max(sz(:,1)),max(sz(:,2)));
end
if checksiz([size(so);size(x);size(cost);size(flag);size(type)],mfilename);
  return
end

p = zeros(size(so));
type_index = find(type == 0);      % Call option
if ~isempty(type_index)
  i = find(flag(type_index) == 0); % Long position
  if ~isempty(i);p(i) = max(so(i)-x(i),zeros(size(i)))-cost(i);end
  i = find(flag(type_index) == 1); % Short position
  if ~isempty(i);p(i) = -max(so(i)-x(i),zeros(size(i)))+cost(i);end
end
type_index = find(type == 1);      % Put option
if ~isempty(type_index)
  i = find(flag(type_index) == 0); % Long option
  if ~isempty(i);p(i) = max(x(i)-so(i),zeros(size(i)))-cost(i);end
  i = find(flag(type_index) == 1); % Short option
  if ~isempty(i);p(i) = -max(x(i)-so(i),zeros(size(i)))+cost(i);end
end
