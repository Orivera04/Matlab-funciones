function clptdscf(f,F,xunit)
% CALL: clptdscf(f,F,xunit) Plot a discrete spectrum [f F]
%  Input to function is 
%	f 	- frequencies 
%	F 	- spectral values
%	xunit	- units of frequency (Hz or rad/sec)
%  Input title of graph from keyboard
nl=length(f);                % Number of f points
fmin=min(f);                 %  and range
fmax=max(f);
Fmax=max(F);
% Plotting range, lengthen axes by 10%  
Fmaxp=Fmax+.1*Fmax;
fminp=fmin-.1*fmax;
fmaxp=fmax+.1*fmax;
%
title1=input('Title ', 's' );
clf                          % Clear any figures
axis([fminp fmaxp 0 Fmaxp])  % Manual scaling
for I=1:nl,
 fplots=[f(I) f(I)];
 Fplot=[0 F(I)];
 plot(fplots,Fplot)          % Plot one line at a time 	
hold on
end
title(title1)
ylabel('Amplitude')
xlabel(['Frequency in ', xunit])

