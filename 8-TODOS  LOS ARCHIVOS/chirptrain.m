% Display the sound signals from chirp and train
load chirp
subplot(2,1,1)
plot(y)
ylabel('Amplitude')
title('Chirp')
load train
subplot(2,1,2)
plot(y)
ylabel('Amplitude')
title('Train')
