%P6-17
%Consider the uplink transmission of voice signals in a 
%single-cell DS-CDMA system with a processing gain of 256. Here we are interested in 
%studying the effect of power control error on the cell capacity by computer 
%simulation. For simplicity, the following assumptions are made:

%(1) The required transmission accuracy is specified by a required Eb/Io of 7 dB.
%(2) The background additive noise is negligible when compared with the multiple access interference.
%(3) The transmission is frame based with a frame duration of 5 ms. All the transmission from mobile users are synchronized in frame.
%(4) Different users have independent power control errors. For each user, the power control error is independent from frame to frame. Over each frame duration, the power control error for each user remains constant.
%(5) Each power control error (in dB) can be modeled as a Gaussian random variable with zero mean and standard deviation (also in dB).

%Due to the power control error, there are chances that the required Eb/Io cannot be guaranteed from time to time. It is required that the outage probability, defined as P(Eb/Io < 10 dB), should be kept below alpha.


%a) Given alpha = 5%, determine the cell capacity for Power Control Error std = 1 dB, 2 dB, and 3dB, respectively.
%b) Given Power Control Error std = 1 dB, determine the cell capacity for alpha = 1%, 2%, and 5%, respectively.

function chap6_func (action)

handle = findobj(gcbf, 'Tag', 'alpha');
alpha = eval(get(handle,'String'));
handle = findobj(gcbf, 'Tag', 'std');
std_pe = eval(get(handle, 'String'));
handle = findobj(gcbf, 'Tag', 'Gp');
Gp = eval(get(handle, 'String'));
handle = findobj(gcbf, 'Tag', 'N');
N = eval(get(handle, 'String'));


Nms = 100;
delta_Nms = 90;

for i=1:delta_Nms
   count = 0;
   tmp_Nms(i) = Nms - i;

   for j = 1:N      
      Perr = std_pe * randn(1, tmp_Nms(i));
      I = 0;
      for k = 2:tmp_Nms(i)
         I = I + 10^(0.1*Perr(k));
      end
      SIR = Perr(1) - 10*log10(I);
      EsIo = SIR + 10*log10(Gp);
      if EsIo < 7
         count = count + 1;
      end
   end
   Prob(i) = count/N;
end
Ref(1:delta_Nms) = alpha/100;
plot(tmp_Nms, Prob, 'b-+');
grid on;
hold on;
plot(tmp_Nms, Ref, 'g.-');
xlabel('Number of Mobiles');
ylabel('Outage Probability');
hold off;
   
