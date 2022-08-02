function y = fitrange(x, low, high)

% Y = fitrange(X,LOW,HIGH) linearly scale X so that its values fall in the
%        fitrange [LOW,HIGH]

% Copyright (C) 1993 James Ashton, Australian National University.  You can
% do what you like with this file as long as this notice stays with it.


xmin = min(min(x));
xmax = max(max(x));

y = low + (x - xmin) * (high - low) / (xmax - xmin);
