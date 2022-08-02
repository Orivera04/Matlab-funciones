function trozos()
for x=-5:0.1:5
if x>=-5 & x<=-3
    x=-5:0.1:-3;
    y=0.*ones(size(x));
    plot(x,y);
    axis([-6 6 -1 6]);
    x1=[-3,-3];y1=[0,2];
    plot(x1,y1,'--r');
    hold on
elseif x>-3 & x<=-2
    x=-3:0.1:-2;
    y=x+5;
    plot(x,y);
    %axis([-6 6 -1 6]);
    x1=[-2,-2];y1=[3,4];
    plot(x1,y1,'--r');
elseif x>-2 & x<=2
    x=-2:0.1:2;
    y=x.^2;
    plot(x,y);
    %axis([-6 6 -1 6]);
    x1=[2,2];y1=[2,4];
    plot(x1,y1,'--r');
elseif x>2.01 & x<=3
    x=2.01:0.1:3;
    y=x;
    plot(x,y);
    %axis([-6 6 -1 6]);
    x1=[3,3];y1=[0,3];
    plot(x1,y1,'--r');
elseif x>3 & x<=5
    x=3.01:0.1:5;
    y=0.*ones(size(x));
    plot(x,y);
    %axis([-6 6 -1 6]);
end
end