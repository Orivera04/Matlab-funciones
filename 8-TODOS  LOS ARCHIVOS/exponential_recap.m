%% Exponential Chapter Recap
% This is an executable program that illustrates the statements
% introduced in the Exponential Chapter of "Experiments in MATLAB".
% You can access it with
%
%    exponential_recap
%    edit exponential_recap
%    publish exponential_recap
%
%  Related EXM programs
%
%    expgui
%    wiggle

%% Plot a^t and its approximate derivative
    a = 2;
    t = 0:.01:2;
    h = .00001;
    y = 2.^t;
    ydot = (2.^(t+h) - 2.^t)/h;
    plot(t,[y; ydot])

%% Compute e
    format long
    format compact
    h = 1;
    while h > 2*eps
        h = h/2;
        e = (1 + h)^(1/h);
        disp([h e])
    end

%% Experimental version of exp(t)
    t = rand
    s = 1;
    term = 1;
    n = 0;
    r = 0;
    while r ~= s
       r = s;
       n = n + 1;
       term = (t/n)*term;
       s = s + term;
    end
    exp_of_t = s

%% Value of e
    e = expex(1)

%% Compound interest
    fprintf('             t        yearly       monthly     continuous\n')
    format bank
    r = 0.05;
    y0 = 1000;
    for t = 0:20
       y1 = (1+r)^t*y0;
       y2 = (1+r/12)^(12*t)*y0;
       y3 = exp(r*t)*y0;
       disp([t y1 y2 y3])
    end

%% Payments for a car loan
    y0 = 20000
    r = .10
    h = 1/12
    n = 36
    p = (1+r*h)^n/((1+r*h)^n-1)*r*h*y0

%% Complex exponential
    theta = (1:2:17)'*pi/8
    z = exp(i*theta)
    p = plot(z);
    set(p,'linewidth',4,'color','red')
    axis square off

%% Famous relation between e, i and pi
    exp(i*pi)

%% Use the Symbolic Toolbox
    exp(i*sym(pi))
