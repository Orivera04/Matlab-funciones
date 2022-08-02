% CLEX95DT.M  Create data for processing
%  for Example 9.5 in file CLEX95.MAT
% Result has Resolution= 1/NTs= 1Hz; Valid Range is to 64Hz 
%   (There will be symmetry about 64Hz ie at 64+(64-20)=108Hz)
%  Shifting the zero point will product a symmetric spectrum
N=128;
Ts=1/128;			% Nyquist frequency is 64 Hz
t=0:Ts:Ts*(N-1);		% delt = 0, 1/128, ... 127/128, 1
ft=sin(2*pi*20*t);
% Add random noise
ft=ft+randn(size(t));
% Save N,Ts,t,ft
save clex95.mat 
