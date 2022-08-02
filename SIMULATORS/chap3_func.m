%Chapter 3.
%This simulation studies the transmission performance of pi/4-DQPSK modulation scheme.   
%A randomly generated bit stream is first modulated using pi/4-DQPSK.  The modulated
%symbol sequence then goes through a flat Rayleigh fading channel with additive white
%Gaussian noise.  The bit errorr are counted and the bit error rate (BER) is plotted 
%versus the received SNR/bit for three VmTs values.  The performance of pi/4-DQPSK over 
%an AWGN channel is also plotted as a reference. 
function chap3_func (action)

handle = findobj(gcbf, 'Tag', 'min');
min = eval(get(handle,'String'));
handle = findobj(gcbf, 'Tag', 'max');
max = eval(get(handle, 'String'));
handle = findobj(gcbf, 'Tag', 'Npass');
Npass = eval(get(handle, 'String'));
handle = findobj(gcbf, 'Tag', 'VmTs1');
VmTs1 = eval(get(handle, 'String'));
handle = findobj(gcbf, 'Tag', 'VmTs2');
VmTs2 = eval(get(handle, 'String'));
handle = findobj(gcbf, 'Tag', 'VmTs3');
VmTs3 = eval(get(handle, 'String'));
handle = findobj(gcbf, 'Tag', 'N');
N = eval(get(handle, 'String'));




VmTs(1) = VmTs1;
VmTs(2) = VmTs2;
VmTs(3) = VmTs3;

%additive noise
   wcn = randn(1, N/2)/sqrt(2);
   wsn = randn(1, N/2)/sqrt(2);

   delta = (max - min) / (Npass-1);

for w = 1:3

%Rayleigh fading
   [RLn, var_r] = Rayleigh(VmTs(w), N/2, 50);

for i = 1:Npass   
   SNR_db(i) = min+(i-1)*delta;
   std_n = 10^(-0.05*(6+SNR_db(i)));
   %noise in AWGN channel
   Wcn = std_n * wcn;
   Wsn = std_n * wcn;
   Wn = Wcn + j*Wsn;
   
   %Generate bit sequence
   x = rand(1, N);
   for k = 1:N
      if x(k) < 0.5
         x(k) = 0;
      else
         x(k) = 1;
      end
   end
   
   %pi/4-DQPSK modulation.
   for k = 1:N/2
      if (x(2*k-1) == 0 & x(2*k) == 0)
         phi(k) = pi/4;
      elseif (x(2*k-1) == 0 & x(2*k) == 1)
         phi(k) = 3*pi/4; 
      elseif (x(2*k-1) == 1 & x(2*k) == 1)
         phi(k) = 5*pi/4;
      elseif (x(2*k-1) == 1 & x(2*k) == 0)
         phi(k) = 7*pi/4;
      end
      % let initial phase = 0
      if k == 1
         In(k) = cos(phi(k));
         Qn(k) = sin(phi(k));
      else
         In(k) = In(k-1)*cos(phi(k)) - Qn(k-1)*sin(phi(k));
         Qn(k) = In(k-1)*sin(phi(k)) + Qn(k-1)*cos(phi(k));      
      end   
         Xn(k) = In(k) + j*Qn(k);
   end
   %AWGN
   Rn = Xn + Wn;
   
   %Rayleigh fading
   Tn = Xn.*RLn + Wn;

   %receiver
   a = pi4dqpsk_rx(Rn, N);
   b = pi4dqpsk_rx(Tn, N);
   
   %calculate probability
   NumErrors_AWGN = 0;
   for k=1:N
      if (a(k)~=x(k))
         NumErrors_AWGN = NumErrors_AWGN + 1;
      end
   end
   Pe_AWGN(i) = NumErrors_AWGN/N;
   
   NumErrors_RAYLEIGH = 0;
   for k=1:N
      if (b(k)~=x(k))
         NumErrors_RAYLEIGH = NumErrors_RAYLEIGH + 1;
      end
   end
   Pe_RAYLEIGH(w,i) = NumErrors_RAYLEIGH/N;

   
end
end

grid on;
semilogy(SNR_db, Pe_RAYLEIGH(1, :), '-.g*');
hold on;
semilogy(SNR_db, Pe_RAYLEIGH(2, :), '-.go');
semilogy(SNR_db, Pe_RAYLEIGH(3, :), '-.g');


semilogy(SNR_db, Pe_AWGN, 'b-');

xlabel('SNR/Bit (dB)');
ylabel('Probability of Error');
legend('VmTs1', 'VmTs2', 'VmTs3', 'AWGN', 0);
hold off;
return;
  
