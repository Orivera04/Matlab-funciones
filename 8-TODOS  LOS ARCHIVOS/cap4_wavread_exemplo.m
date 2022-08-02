% cap4_wavread_exemplo
function cap4_wavread_exemplo ( )
[S,fs]=wavread('TestSnd.wav'); % Le 'TestSnd.wav'
subplot(2,1,1)   % Exibe os dois canais
plot(S(:,1))
title('Canal 1')
subplot(2,1,2)
plot(S(:,2))
title('Canal 2')
sound(S,fs)      % Executa audio