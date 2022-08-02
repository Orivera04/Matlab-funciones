% cap4_wavwrite_exemplo
function cap4_wavwrite_exemplo ( )
[S1,fs1]=wavread('TestSnd.wav'); % Le 'TestSnd.wav'
display('TestSnd.wav')
wavplay(S1,fs1)
display('SOUND1.wav')
[S2,fs2]=wavread('SOUND1.wav');  % Le 'SOUND1.wav'
wavplay(S2,fs2)
S3=[S1;S2 S2];       % 'Emendar os dois sons
fs3=fix((fs1+fs2)/2) % com frequencia media
wavwrite(S3,fs3,'cap4.wav'); % Grava arquivo
display('TestSnd & SOUND1');
wavplay(S3,fs3)