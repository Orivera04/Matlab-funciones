function y = calcy()
% calcy calculates y as a function of x
% Format of call: calcy(x)
% y  =  1     if   x < -1
% y  =  x^2   if   -1 <= x <= 2
% y  =  4     if   x > 2

    t=-3:0.1:-1;
    y = ones(size(t));
    plot(t,y);
    hold on;

    t=-1:0.1:2;
    y = t.^2;
    plot(t,y);

    t=2:0.1:4;
    y = 4*ones(size(t));
    plot(t,y);

    hold off
end
