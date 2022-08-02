function chap4b_func (action)

handle = findobj(gcbf, 'Tag', 'Type');
Type = get(handle,'Value');
handle = findobj(gcbf, 'Tag', 'ff_tap');
FFTap = eval(get(handle,'String'));
handle = findobj(gcbf, 'Tag', 'fb_tap');
FBTap = eval(get(handle,'String'));
handle = findobj(gcbf, 'Tag', 'DSignal');
DSignal = get(handle,'Value');
handle = findobj(gcbf, 'Tag', 'N');
N = eval(get(handle,'String'));

vmT = 0.0005;
X = rand(1, N);

Kdb = 5;

%Rician
[RCn, var1] = Rician(vmT, N, 20000, Kdb);
%RAYLEIGH
[RLn, var2] = Rayleigh(vmT, N, 20000);

% normalized noise
wn=randn(1, N);


RC_K = 10^(0.1*Kdb);
global A cn tn;
A = 1;
Npass = 8;
max = 40;
min = 0;
delta = (max - min) / Npass;

for i = 1:Npass+1   
   SNR_db(i) = (i-1)*delta + min;
   
   tn(1:FBTap)= 0;
   cn(1:FFTap+FBTap) = 0;
   if(mod(FFTap, 2) == 0 & FFTap ~= 0)
      error ('Even number of ff-taps')
      return;
   end
   if(FFTap > 0)
   tmp = (FFTap + 1)/2;
   cn(tmp) = 0.5;
   end

for k = 1:N
   if X(k) < 0.5
      X(k) = 0;
      An(k) = -A;
   else
      X(k) = 1;
      An(k) = A;
   end
end

%[RCn, var1] = Rayleigh(0.001, N, 1);

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

%Adaptive DFE
if FFTap==0
   tmp = 0;
else
   tmp = FFTap-1;
end

shift = tmp/2;


for k =1:N-tmp
   [pn(k)] = DFE(Rn(k:k+tmp), Pi, FFTap, FBTap, An(k+shift), DSignal);
   if pn(k) > 0
      Z(k) = 1;
   else
      Z(k) = 0;
   end   
end

error_dfe = 0;
for k = 1: N-tmp
   if Z(k) ~= X(k+shift)
      error_dfe = error_dfe + 1;
   end
end
error_dfe;
BER_dfe(i) = error_dfe/N;

end



%Plot graphs
semilogy(SNR_db, BER_dfe, 'b-+');
grid on;
hold on;
semilogy(SNR_db, BER_ne, 'g-*');


xlabel('SNR/bit (dB)');
ylabel('Bit Error Rate');
legend('Adaptive DFE','no equalization',0);
hold off;
return;
