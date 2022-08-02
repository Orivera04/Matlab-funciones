SNR = (2:2:20)';
ebr_array = zeros(SNR);

for i = 1:length(SNR),
	ebr_array(i) = ebr_opti(SNR(i));
end

plot(SNR, ebr_array);
xlabel('SNR (signal to noise ratio) (dB)');
ylabel('log10(error bit rate)');
