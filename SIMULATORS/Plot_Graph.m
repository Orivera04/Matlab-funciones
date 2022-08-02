%Chapter 2.

%This function generates different plots (Amplitude, Amplitude pdf, Phase, Phase pdf,
%LCR, AFD, Amplitude Correlation) for a Rayleigh fading channel.

function Plot_Graph (action)
handle = findobj(gcbf, 'Tag', 'GraphType');
graph_type = get(handle,'Value');
handle = findobj(gcbf, 'Tag', 'Velocity');
v = eval(get(handle,'String'));
handle = findobj(gcbf, 'Tag', 'fc');
fc = eval(get(handle,'String'));
handle = findobj(gcbf, 'Tag', 'Ts');
Ts = eval(get(handle,'String'));
handle = findobj(gcbf, 'Tag', 'N');
N = eval(get(handle,'String'));
std = 50;

vm = (v*1000/3600)*(fc*1e6)/3e8;
fm = vm * Ts / 1000;

%generate Rayleigh fading channel by Inverse Discrete Fourier Transform.
[magnitude, theta, corr, var_r] = chan_sim(fm, N, std);

handle = findobj(gcbf, 'Tag', 'Axes1');
T = (N-1) * Ts / 1000;
std_r = sqrt(var_r);

switch graph_type
case 1 %Amplitude
   plot(magnitude);
   xlabel('Time(ms)');
   ylabel('Amplitude');

case 2 %Amplitude_pdf   
   [Y, X] = find_pdf(magnitude, N, 'Amplitude_pdf');
   plot(X, Y, 'b-');
   hold on;
   t = linspace(0, 10, 500);
   f = (t/var_r).*exp(-(t.^2)/(2*var_r));
   
   handle = findobj(gcbf, 'Tag', 'Axes1');

   plot(t, f, 'g-.');
   xlabel('Amplitude');
   ylabel('Probability density function');
   legend('simulation', 'theoretical', 0);
   
   hold off;
case 3 %Phase
   plot(theta);
   xlabel('Time(ms)');
   ylabel('Phase');

   
case 4 %Phase_pdf
   [Y, X] = find_pdf(theta, N, 'Theta_pdf'); 
   plot(X, Y, 'b-');
   hold on;
   t = linspace(-pi, pi, 200);
   f = 1/(2*pi);
   plot(t, f, 'g-.');
   hold off;
   
   xlabel('Phase');
   ylabel('Probability density function');
   legend('simulation', 'theoretical', 0);

case 5 %LCR
   [Y, X, R] = find_lcr(magnitude, N, T, std_r);   
   semilogy(X, Y, 'b-');
   hold on;
   R = R /(sqrt(2)*std_r);
   Nr = sqrt(2*pi)*vm.*R.*exp(-R.^2);
   semilogy(X, Nr, 'g-.');
   
   xlabel('Normalized threshold (dB)');
   ylabel('LCR');
   legend('simulation', 'theoretical', 0);

   hold off;

   
case 6 %AFD
   [Y, X, R] = find_afd(magnitude, N, Ts, std_r);
   semilogy(X, Y, 'b-');
   hold on;
   R = R /(sqrt(2)*std_r);
   Xr = (exp(R.^2)-1)./(sqrt(2*pi)*vm*R);
   semilogy(X, Xr, 'g-.');
   
   xlabel('Normalized threshold (dB)');
   ylabel('AFD');
   legend('simulation', 'theoretical', 0);

   hold off;
   
case 7 %Correlation   
   for k = 1 : 101
         delta_t(k) = k*2*Ts;      
      end
      plot(delta_t, corr);
      
      xlabel('Time separation (ms)');
      ylabel('Correlation coefficient');

end
  
set(handle,'XMinorTick','on');
grid on;
return;   
