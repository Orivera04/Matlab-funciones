echo on
% cap3_loglog_exemplo( )
x=linspace(0,pi,20);
y=cos(x);
ei=std(y)*0.3*ones(1,20);
es=std(y)*0.1*ones(1,20);
errorbar(x,y,ei,es)