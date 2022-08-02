% f10_22 same as L10_13
% Copyright S. Nakamura, 1995
figure(1)
set(gcf,'NumberTitle','off','Name',...
        'Figure10.22; List 10.13')

clear, clf, hold off
k=80.2; ro=7870;c=447;TL=0;TR=200;
alpha = k/ro/c; Dx=.05; 
A=[-2  1  0  0  0  0  0  0  0; ...
    1 -2  1  0  0  0  0  0  0; ...
    0  1 -2  1  0  0  0  0  0; ...
    0  0  1 -2  1  0  0  0  0; ...
    0  0  0  1 -2  1  0  0  0; ...
    0  0  0  0  1 -2  1  0  0; ...
    0  0  0  0  0  1 -2  1  0; ...
    0  0  0  0  0  0  1 -2  1; ...
    0  0  0  0  0  0  0  1 -2]*alpha/Dx^2;
S=[TL; 0; 0; 0; 0; 0; 0; 0;TR]*alpha/Dx^2;
T=[40;40;40;40;40;40;40;40;40] ;
T=200*ones(size(T));    
n=0; t=0; h=20; m=0;
%
  axis([0,10,0,220])
  j=[0,1:length(T),length(T)+1];
  T_plot=[TL, T',TR];
  plot(j,T_plot) 
  hx=text( j(2)+0.05, T_plot(2)-10,['t = ',int2str(t),' sec']);
  set(hx,'FontSize',[15])
  xlabel('Point number, i')
  ylabel('T (degrees C)')
%
for k=1:5
  for m=1:10 
    n=n+1; 
    k1 = h*(A*T+S);
    k2 = h*(A*(T+k1/2) + S);
    k3 = h*(A*(T+k2/2) + S);
    k4 = h*(A*(T+k3) + S);
    T = T+(k1 + 2*k2 + 2*k3 + k4)/6;
    t=h*n;
  end
  hold on
  j=[0,1:length(T),length(T)+1];
  T_plot=[TL, T',TR];
  plot(j,T_plot) 
  hy=text( j(k+2)-0.1, T_plot(k+2),[int2str(t),'s']);
  set(hy,'FontSize',[15])
end

