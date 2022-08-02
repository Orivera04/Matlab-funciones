function treeplot(p,c,d)
%TREEPLOT Plot a picture of a tree.
%	TREEPLOT(p,c,d)
%	    p is a vector of parent pointers, with p(i) == 0 for a root.
%	    c is a color and character for nodes, or '' to not plot nodes.
%	    d is a color and character for edges, or '' to not plot edges.
%	    c or d may be omitted, and reasonable defaults are used.
%
%	See also ETREE, TREELAYOUT, ETREEPLOT.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

[x,y,h]=treelayout(p);
f = find(p~=0);
pp = p(f);
X = [x(f); x(pp); NaN*ones(size(f))];
Y = [y(f); y(pp); NaN*ones(size(f))];
X = X(:);
Y = Y(:);

if nargin == 1,
	n = max(size(p));
	if n < 500,
		plot (x, y, 'ro', X, Y, 'r-');
	else,
		plot (X, Y, 'r-');
	end;
else,
        [ignore, clen] = size(c);
        if nargin < 3, 
		if clen > 1, 
			d = [c(1:clen-1) '-']; 
		else,
			d = 'r-';
		end;
	end;
	[ignore, dlen] = size(d);
	if clen>0 & dlen>0
		plot (x, y, c, X, Y, d);
	elseif clen>0,
		plot (x, y, c);
	elseif dlen>0,
		plot (X, Y, d);
	else
	end;
end;
xlabel(['height = ' int2str(h)]);
axis([0 1 0 1]);
