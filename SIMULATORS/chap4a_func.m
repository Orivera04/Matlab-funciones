function chap4a_func (action)

handle = findobj(gcbf, 'Tag', 'TapNum');
Tap = eval(get(handle,'String'));
handle = findobj(gcbf, 'Tag', 'KFactor');
KFactor = get(handle,'Value');
handle = findobj(gcbf, 'Tag', 'vmT');
vmT = eval(get(handle,'String'));
handle = findobj(gcbf, 'Tag', 'DSignal');
DSignal = get(handle,'Value');
handle = findobj(gcbf, 'Tag', 'N');
N = eval(get(handle,'String'));


 
X = rand(1, N);
switch KFactor
case 1
   Kdb = 5;
case 2
   Kdb = 10;
end

%Rician
[RCn, var1] = Rician(vmT, N, 250, Kdb);

%RAYLEIGH
[RLn, var2] = Rayleigh(vmT, N, 250);

% normalized noise
wn=randn(1, N);

RC_K = 10^(0.1*Kdb);
global A bn;
A = 1;
Npass = 8;
max = 40;
min = 0;
delta = (max - min) / Npass;

for i = 1:Npass+1  
   SNR_db(i) = (i-1)*delta + min;
   
   bn(1:Tap) = 0;
   tmp = (Tap + 1)/2;
   bn(tmp) = 0.5;

for k = 1:N
   if X(k) < 0.5
      X(k) = 0;
      An(k) = -A;
   else
      X(k) = 1;
      An(k) = A;
   end
end

A1n = An.*abs(RCn);  %length N

A2n = An.*real(RLn); %length N
 

%Noise
   std_n = sqrt(2*(1.5+RC_K))*sqrt(var1)*10^(-0.05*SNR_db(i));
   Wn = std_n * wn;


Pi = (1.5 + RC_K)*2*var1;
Rn(1) = A1n(1);
for k=2:N
   Rn(k) = A1n(k) + A2n(k-1);
end
 
Rn = Rn + Wn;

% no equalization
error_ne = 0;
for k = 1: N
   if Rn(k) > 0
      V(k) = 1;
   else
      V(k) = 0;
   end   

   if V(k) ~= X(k)
      error_ne = error_ne + 1;
   end
end
BER_ne(i) = error_ne/N;

%Adaptive linear equalizer

tmp = Tap-1;
shift = tmp/2;

for k =1:N-tmp
   [xn(k)] = linear_eq(Rn(k:k+tmp), Pi, Tap, An(k+shift), DSignal);
   if xn(k) > 0
      Y(k) = 1;
   else
      Y(k) = 0;
   end   
end

error_lin = 0;
for k = 1: N-tmp
   if Y(k) ~= X(k+shift)
      error_lin = error_lin + 1;
   end
end
error_lin;
BER_lin(i) = error_lin/N;

end


%Plot graphs
semilogy(SNR_db, BER_lin, 'b-+');
grid on;
hold on;
semilogy(SNR_db, BER_ne, 'g-*');


xlabel('SNR/bit (dB)');
ylabel('Bit Error Rate');
legend('Linear equalization','no equalization',0);
hold off;
return;
