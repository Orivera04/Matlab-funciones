clc; disp('Time Domain support utilitites:'); disp('');
disp('');
disp('Step Response');
disp('Transient Response');
disp('Simulink Toolbox');
disp(' '); disp('Press any key to continue.'); pause;

clc; disp('System response to a Step Input.');
disp('Example from problem 9.36c.');
disp('G(z) = K*(z+0.5)/(z-1)^2');
disp('D(z) = (z-1)/(z-.152524)'); 
disp('K = .2785');
disp('Open Loop Transfer function = .2785*(z-.5)/((z-1)*(z-.152524))');
num = .2785*[1 0.5]; den = conv([1 -1],[1 -.152524]);
disp(' ');
disp('num =  0.2785   0.1393');
disp('den =  1.0000  -1.1525   0.1525');
disp(' '); 
disp('Closed loop (unit negative feedback) transfer function gets computed:');
disp('With Control Toolbox by: [n,d] = cloop(num,den,-1)');
disp('Or with MCSTD Toolbox by: n = num, d = poly_add(den,num)');
%
if ( exist('cloop') ) % MATLABs' Control System Toolbox
  eval('[n,d] = cloop(num,den,-1)');
else
  n = num, d = poly_add(den,num)
end;
disp('Press any key to continue.'); pause;
%
clc; disp('Many ways exist to check the system response to a Unit Step.');
disp(' '); disp('With the Control Toolbox : [y,x] = dstep(n,d,21);'); disp(' ');
disp('Or to Convolve the Input z-transform with the transfer function, and');
disp('then deconvolve the results numerator and results denominator (see demo # 7).');
disp(' '); 
disp('[q,r] = deconv([conv(n,[1 0]) zeros(1,20)],conv(d,[1 -1])); y = [0; q.''];');
disp(' '); disp('Both give you the output for 0 <= t <= 20');
disp(' ');
disp('You could even compute the output in the state-space form.');
disp('See transient response in next next example for state space form.');
t = 0:20;
if ( exist('dstep') ) % MATLABs' Control System Toolbox
  eval('[y,x] = dstep(n,d,21);');
else
  [q,r] = deconv([conv(n,[1 0]) zeros(1,20)],conv(d,[1 -1])); y = [0; q.'];
end;
disp(' '); disp('Press any key to display the plot.'); pause;
stairs(t,y); grid; title('Closed Loop response to a Unit Step');
xlabel('Time (seconds)'); ylabel('Amplitude');
% meta demo6
pause; clear num den n d x y q r;

clc; disp('System Response to any Particular Input');
disp('Example from problem 9.08c'); disp(' ');
num = 1; den = [1 .5]; dt = 1;
disp('Forward Transfer function :');
num = (den(1)*num/den(2))*(1-exp(-den(2)*dt)); den = [1 -exp(-den(2)*dt)];
disp(' '); disp('num =  0.7869,   den =  1.0000   -0.6065');
disp(' '); disp('Discrete sample displaying for 0 <= t <= 20');
disp('Input r*(t) = [0 .5 1 .5 0], and r*(t) = 0 for t >= 4');
t = 0:20; r = 0*t; r(2:4) = [.5 1 .5];
disp(' '); disp('With the Control Toolbox: [y,x] = dlsim(num,den,r);');
disp(' '); disp('OTHERWISE, the state-space approach can be used.');
disp('Convert Transfer function to State-Space representation:');
disp('[a,b,c,d] = tf2ss(num,den);'); 
[a,b,c,d] = tf2ss(num,den);
disp(' '); disp('Initialize all state integrators to 0 : x = 0*diag(a);'); 
x = 0*diag(a);
disp(' '); disp('Propogate the input into the states for all data:');
disp('for ii = 2:length(r); x(:,ii) = a*x(:,ii-1)+b*r(:,ii); end;');
for ii = 2:length(r); x(:,ii) = a*x(:,ii-1)+b*r(:,ii); end;
disp(' '); 
disp('Calculate the outputs (in our case, only one output): y = c*x+d*r;'); 
y = c*x+d*r; 
disp(' '); disp('Press any key to display the plot.'); pause;
sbplot(211);
plot(t,r,'-',t,r,'o'); grid; title('Input Signal');
xlabel('Time (seconds)'); ylabel('Amplitude');
stairs(t,y.'); grid; title('Output Signal');
xlabel('Time (seconds)'); ylabel('Amplitude');
% meta demo6
pause; sbplot(111); clg; clear num den dt t r a b c d x y ii;

clc;
disp('The Simulink toolbox was designed to handle/display time series')
disp('analysis of a large variety of input signals, device models, and output');
disp('display devices.  Simulation in the time domain is easily accomplished');
disp('with very little effort.  Most control analysis is done in the frequency'); 
disp('domain, with system simulation/validation in the time domain.  The'); 
disp('Simulink toolbox is not limited to linear systems analysis, it contains');
disp('many non-linear device models for simulation.  With the addition of');
disp('power-spectral analysis display device, even frequency analysis is');
disp('possible.  Although Simulink appears very powerful, the "idealized" models');
disp('should not be used to totally replace hands-on experience in a laboratory.');
disp('Several simulations have been prepared in the problems and figures');
disp('directories.');
if ( exist('simulink') )
  eval('mcstd61');
else
  disp(' ');
  disp('Simulation not run because Simulink Toolbox is required for this example.');
end;
pause;
