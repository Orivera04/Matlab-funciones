%P7-17(c)
%Statistics of user mobility patterns are important for designing efficient hand-off 
%management schemes. Due to the high degree of randomness in user movement patterns, 
%it is in general a very complex task to obtain the statis-tics. Certain assumptions 
%on user movements need to be made to simplify the task, even by computer simulation.
%Consider a hexagonal cell with cell radius R=5km. Assume that mobile users are 
%uniformly distributed in the cell and all the mobiles are active. Over a time period 
%of T, each mobile travels in a straight line at a constant velocity. The initial 
%direction is uniformly distributed over[0,2pi]. The direction change in the next 
%period is uniformly distributed over [-alpha, alpha], where alpha <= pi/2. The 
%velocity can be modeled as a Gaussian random variable with mean speed u and standard 
%deviation std (the negative values are unlikely when mean speed >> standard deviation
%and are to be replaced by 0), and is independent from period to period. The movement 
%pattern of each mobile is independent of those of any other mobiles. We want to obtain 
%the following mobility statistics based on computer simulation.

%(c) Consider there are 200 active mobiles in the cell all the time. When a mobile 
%moves out of the cell, a new mobile is admitted to the cell with an initial location 
%uniformly distributed in the cell. Given T = 1 minute, alpha = 0.25pi, standard deviation
%= 5km/hour, determine the mean rate that the mobiles hand off to a neighbouring cell for 
%mean speed equal to 40, 45, and 50 km/hour, respectively.  Comment on the effect of mean speed.

function chap7c_func (action)

handle = findobj(gcbf, 'Tag', 'alpha');
alpha = eval(get(handle,'String'));
handle = findobj(gcbf, 'Tag', 'std');
std = eval(get(handle, 'String'));
handle = findobj(gcbf, 'Tag', 'R');
R = eval(get(handle, 'String'));
handle = findobj(gcbf, 'Tag', 'Nms');
Nms = eval(get(handle, 'String'));



%parameters
N = 120;    %number of mins for simulation
Nms = 200;  %number of mobile users
sigma = std/60; %km/min


for i = 1:3
u(i) = 40+(i-1)*5;   %km/hour
u_min(i) = u(i)/60;  %km/min   
%initial direction uniformly distributed between 0 to 2pi
D = 2* pi*rand(1, Nms);


%initial mobile user locations

r = R*rand(1, Nms);
deg = 360*rand(1, Nms);
x = r.*cos(deg);
y = r.*sin(deg);
Tot_cnt = 0;

for j= 1:N
   %direction change in next period uniformly distributed between -pi/2 to pi/2
   delta_D = 2* alpha * rand(1, Nms) - alpha;

   %velocity modeled by a Gaussian random distribution
   V = sigma * randn(1, Nms) + u_min(i);
      
   count = 0;
      
   delta_x = V.*cos(D);
   delta_y = V.*sin(D);
   x = x + delta_x;
   y = y + delta_y;
      
   for k=1:Nms
      %distance from Base Station;
      L = sqrt(x(k)^2 + y(k)^2);
      
      if (L >= R) %mobile user outside of cell coverage
         x(k) = R*rand(1)*cos(360*rand(1));
         y(k) = R*rand(1)*sin(360*rand(1));
         D(k) = 2*pi*rand(1);
         count = count + 1; %number of handoffs in the period.
      else
         D(k) = D(k) + delta_D(k);
      end
   end
   Tot_cnt = Tot_cnt + count;
end  
HF_rate(i) = Tot_cnt/N; %mean handoff rate.
end
plot(u, HF_rate, 'b+-');
xlabel('mean speed(km/hr)');
ylabel('mean handoff rate (handoffs/min)');

grid on;
return;
