function undo(N)

%UNDO   Erase the last object plotted on the graph.  The object can
%       be a curve or text.  Repeating "undo" erases further back in
%       time. UNDO does not work for title and labels; to erase
%       these, use "title('')" or "xlabel('')" 
 
 %       kwong@mcs.anl.gov 1/19/93
 % 		Modified A. Knight, April 1999 

h = get(gca,'children');
if length(h) > 0 
   if nargin==0
	  delete(h(1))
	else
	  delete(h(1:N));
  end
end
