%P5-14
%Consider a cellular system with hexagonal cells and with a frequency reuse factor 
%of 7.  Consider the forward link transmission where the co-channel interference 
%resulting only from the 6 co-channels (base stations) in the first tier.  The 
%propagation environment is characterized by the lognormal shadowing as described by 
%Eqs. (2.4.15)-(2.4.16), with path loss exponent k and the standard deviation .  
%All the base stations have the same transmitted signal power and the same values for
%do and Lp(do) respectively.  The required instantaneous signal to co-channel 
%interference ratio (S/I) is 18 dB.


%(a) Assume that the mobile user location is uniformly distributed in the cell with 
%d > do, find the probability that the instantaneous (S/I) value is below 18 dB (1) 
%for std = 8dB and k = 2, 2.5, 3, 3.5, and 4, respectively, and (2) for k = 4 and std =   
%7, 8, and 9 dB, respectively.

%(b) Consider the worst case scenario where the mobile user is at the cell boundary,
%find the probability that the instantaneous (S/I) value is below 18 dB (1) for 
%std = 8dB and k = 2, 2.5, 3, 3.5, and 4, respectively, and (2) for k = 4 and std =   
%7, 8, and 9 dB, respectively.


function chap5_func (action)

handle = findobj(gcbf, 'Tag', 'Mode');
Mode = get(handle,'Value');
handle = findobj(gcbf, 'Tag', 'GraphType');
GraphType = get(handle, 'Value');
handle = findobj(gcbf, 'Tag', 'ReqSI');
ReqSI = eval(get(handle, 'String'));

switch GraphType
case 1
   
std_e = 8;

for n=0:4   
   k(n+1) = 2 + n*0.5;
   N = 500 + 100 * n;
   Repeat = 10;
R = 5;
Lp0 = 0; %dB

d0 = 0.5;%km

a = sqrt(3)/2*R;

bs_x = [0, 1.5*R, 4.5*R,  3*R, -1.5*R, -4.5*R, -3*R];
bs_y = [0,   5*a,     a, -4*a,   -5*a,     -a,  4*a];

switch Mode
   case 1
   %generate uniformly distributed samples inside the cell.
   r = R*rand(N);
   deg = 360*rand(N);
   case 2
   
   %generate uniformly distributed samples
   r(1:N) = R;
   deg(1:N) = 0;
end


x = r.*cos(deg);
y = r.*sin(deg);
count = 0;
root_3 = sqrt(3);
for w = 1:Repeat
for (i = 1:N)
   temp1 = root_3*(x(i)-R);
   temp2 = root_3*(x(i)+R);
  
   if ( y(i)<= root_3/2*R & y(i)>= -root_3/2*R & y(i) <= -temp1 & y(i) >= -temp2 & y(i) <= temp2 & y(i) >= temp1 & sqrt(y(i)^2 + x(i)^2) > d0)
      count = count + 1;
      coor(count, :) = [x(i) y(i)];
   end
end
end
temp = 0;
for i = 1:count
   shadow = std_e*randn(1,7);
   for j = 1:7      
      distance(j) = sqrt((coor(i, 1) - bs_x(j))^2 + (coor(i, 2) - bs_y(j))^2);
       
      Lpd(j) = Lp0 + 10 * k(n+1) * log (distance(j)/d0)+ shadow(j);

   end
Pr = -Lpd;
Pi = 0;
for j = 2:7
   Pi = Pi + 10^(0.1*Pr(j));    
end
Pi_db = 10*log10(Pi); %in dB
SIR = Pr(1) - Pi_db;
if SIR < ReqSI;
   temp = temp + 1;
end
end
Prob(n+1) = temp/count;
end
handle = findobj(gcbf, 'Tag', 'Axes1');
semilogy(k, Prob, 'b-');

xlabel('Path Loss Exponent k');
ylabel('Outage Probability');

grid on;

case 2
k = 4;

for n=0:2   
std_e(n+1) = 7 + n;
N = 750 + 200 * n;
Repeat = 10;
R = 5;
Lp0 = 0; %dB

d0 = 0.5;%km

a = sqrt(3)/2*R;


bs_x = [0, 1.5*R, 4.5*R,  3*R, -1.5*R, -4.5*R, -3*R];
bs_y = [0,   5*a,     a, -4*a,   -5*a,     -a,  4*a];

switch Mode
   case 1
   %generate uniformly distributed samples inside the cell.
   r = R*rand(N);
   deg = 360*rand(N);
   case 2
   
   %generate uniformly distributed samples
   r(1:N) = R;
   deg(1:N) = 0;
end


x = r.*cos(deg);
y = r.*sin(deg);
count = 0;
root_3 = sqrt(3);
for w = 1:Repeat
for (i = 1:N)
   temp1 = root_3*(x(i)-R);
   temp2 = root_3*(x(i)+R);
  
   if ( y(i)<= root_3/2*R & y(i)>= -root_3/2*R & y(i) <= -temp1 & y(i) >= -temp2 & y(i) <= temp2 & y(i) >= temp1 & sqrt(y(i)^2 + x(i)^2) > d0)
      count = count + 1;
      coor(count, :) = [x(i) y(i)];
   end
end
end
temp = 0;
for i = 1:count
   shadow = std_e(n+1)*randn(1,7);
   for j = 1:7      
      distance(j) = sqrt((coor(i, 1) - bs_x(j))^2 + (coor(i, 2) - bs_y(j))^2);
      Lpd(j) = Lp0 + 10 * k * log (distance(j)/d0)+ shadow(j);
     end
Pr = -Lpd;
Pi = 0;
for j = 2:7
   Pi = Pi + 10^(0.1*Pr(j));
  
end
Pi_db = 10*log10(Pi); %in dB
SIR = Pr(1) - Pi_db;
if SIR < ReqSI;
   temp = temp + 1;
end
end
Prob(n+1) = temp/count;
end
handle = findobj(gcbf, 'Tag', 'Axes1');
semilogy(std_e, Prob, 'b-');

xlabel('Shadowing Standard Deviation (dB)');
ylabel('Outage Probability');

grid on;

end 


return;
