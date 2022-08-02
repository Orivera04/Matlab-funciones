% Example usage of piecewise_eval
%  For       x < -5, y = 2
%  For -5 <= x < 0,  y = sin(x)
%  For  0 <= x < 2,  y = x.^2
%  For  2 <= x < 3,  y = 6
%  For  3 <= x,      y = inf
%
 y = piecewise_eval(-10:10,[-5 0 2 3],{2,'sin(x)','x.^2',6,inf})

