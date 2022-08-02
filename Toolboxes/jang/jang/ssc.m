function tconorm = ssc(a, b, p)
%SSC Schweizer T-conorm using parameter p. 

% J.-S. Roger Jang, 1993

tconorm = 1 - max(0, ((1 - a).^(-p) + (1 - b).^(-p) - 1)).^(-1/p);
