%P7-17(a)
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

%(a)Given T = 1 minute, alpha = 0.25pi, std = 5km/hour find the mean sojourn time 
%(see Subsection 7.3.8) for mean speed equal to 40, 45, and 50 km/hour,respectvely. 
%Comment on the effect of mean speed.

function chap7a_func (action)

%parameters

handle = findobj(gcbf, 'Tag', 'alpha');
alpha = eval(get(handle,'String'));
handle = findobj(gcbf, 'Tag', 'std');
std = eval(get(handle, 'String'));
handle = findobj(gcbf, 'Tag', 'R');
R = eval(get(handle, 'String'));
handle = findobj(gcbf, 'Tag', 'N');
N = eval(get(handle, 'String'));


sigma = std/60; %km/min


for i = 1:3
u(i) = 40+(i-1)*5;   %km/hour
u_min(i) = u(i)/60;  %km/min   
%initial direction uniformly distributed between 0 to 2pi
D0 = 2* pi*rand(1, N);


%initial mobile user locations

r = R*rand(1, N);
deg = 360*rand(1, N);
x = r.*cos(deg);
y = r.*sin(deg);
T = 0;

for j= 1:N

   Done = 0;
   D = D0(j);   
   count = 0;
   curr_x = x(j);
   curr_y = y(j);
   while (Done == 0 & count < 1000)
      count = count + 1; %time for user to reach cell boundary
      %direction change in next period uniformly distributed between -pi/2 to pi/2
      delta_D = 2* alpha * rand(1) - alpha;

      %velocity modeled by a Gaussian random distribution
      V = sigma * randn(1) + u_min(i);

      delta_x = V* cos(D);
      delta_y = V* sin(D);
      curr_x = curr_x + delta_x;
      curr_y = curr_y + delta_y;
      L = sqrt(curr_x^2 + curr_y^2); %distance from Base Station;
      if (L >= R) %mobile user outside of cell coverage
         Done = 1;
      else
         D = D + delta_D;
      end
         
   end
   T = T + count; %total time for all users to reach cell boundary
end
St(i) = T/N; %mean Sojourn time.
end

plot(u, St, 'b+-');
xlabel('mean speed(km/hr)');
ylabel('Sojourn Time (min)');
grid on;
return;
