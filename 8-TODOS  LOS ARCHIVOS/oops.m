function oops(N)

% OOPS Delete the last object plotted on the axes. Repeating "oops" erases
%       further back in time. OOPS does not work for title and labels; to
%       erase these, use "title('')" or "xlabel('')"
 
if nargin==0
  N = 1;
end
h = get(gca,'children');
delete(h(1:N));
