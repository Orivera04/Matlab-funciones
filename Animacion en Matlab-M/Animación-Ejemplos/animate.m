function animate(x,xtitle,y,ytitle,t,speed,axes,vel,one,ts,smoothness)

b=size(x);
b=b(1);
[s,q]=getT(t,b,speed,ts,smoothness);

d=2;
v=1;

T = timer('StartDelay',smoothness,'TimerFcn',{@advance,.1,0,speed});

h=plot(x(d,1),x(d,2),'O',0,0,'X');
xlabel(xtitle)
ylabel(ytitle)

axis(axes);
set(h,'EraseMode','xor','MarkerSize',10)
j=line([0 x(1,1)],[0 y(1,1)]);
k=line([x(1,1) x(1,2)],[y(1,1) y(1,2)]);
l=line([x(1,one) x(2,one)],[y(1,one) y(2,one)]);
set(l,'EraseMode','none','LineWidth',1,'Color','g');
set(j,'EraseMode','xor');
set(k,'EraseMode','xor','Color','r');


   
while(d<q)
    start(T);
    wait(T);
    set(h,'XData',[0,x(s(d),1),x(s(d),2)],'YData',[0,y(s(d),1),y(s(d),2)],'MarkerFaceColor',[1,0,0]);
    set(j,'Xdata',[0 x(s(d),1)],'Ydata',[0 y(s(d),1)]);
    set(k,'Xdata',[x(s(d),1) x(s(d),2)],'Ydata',[y(s(d),1) y(s(d),2)]);
    set(l,'Xdata',[x(s(d-1),one) x(s(d),one)],'Ydata',[y(s(d-1),one) y(s(d),one)]);
    
    d=d+1;
    v=v+1;
end

d=d-1;
set(h,'XData',[0,x(s(d),1),x(s(d),2)],'YData',[0,y(s(d),1),y(s(d),2)],'MarkerFaceColor',[1,0,0]);
set(j,'Xdata',[0 x(s(d),1)],'Ydata',[0 y(s(d),1)]);
set(k,'Xdata',[x(s(d),1) x(s(d),2)],'Ydata',[y(s(d),1) y(s(d),2)]);
set(l,'Xdata',[x(s(d-1),one) x(s(d),one)],'Ydata',[y(s(d-1),one) y(s(d),one)]);
hold
plot(x(:,one),y(:,one),'g')

function [func,q]=getT(t,b,speed,ts,smoothness)
func=zeros(b,1);
b=ts(2)-ts(1);
b=b/(smoothness*speed);
c=1;
q=1;
a=ts(1);
v=0;
while c < b
    v=find(abs(t-a) < smoothness);
    func(c)=v(1);
    a=a+smoothness*speed;
    c=c+1;
end
q=c;

function advance(obj,e,f,a,speed)
