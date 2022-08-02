N = 25;	% number of harmonics
To = 0.2;	% choose period
n = 2*N;
t = linspace(0,To,n+1); % (n+1)th point is one period away
t(end) = []; % throw away undesired last point
f = sawtooth(t,To); % compute sawtooth
Fn = fft(f);% compute FFT
Fn = [conj(Fn(N+1)) Fn(N+2:end) Fn(1:N+1)]; % rearrange values
Fn = Fn/n; % scale results

Bn=-2*imag(Fn(N+2:end));

idx=-N:N;
Fna = 5j./(idx*pi);
Fna(N+1)=5;
Bna=-2*imag(Fna(N+2:end));

Bn_error=(Bn-Bna)./Bna;