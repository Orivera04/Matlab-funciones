% collect training data

data_n = 502;
original = sign(2*rand(data_n,1) - 1);

signal_var = 1.25; 
noise_var = 0.2
noise = randn(data_n,1)*sqrt(noise_var);
SNR = 10*log10(signal_var/noise_var)

received = zeros(data_n,1);

for i=2:data_n,
	received(i) = channel(original(i), original(i-1));
end
polluted_received = received + noise;

subplot(221);
plot(original), title('Original Signals');
axis([1 data_n -3 3]);
subplot(222);
plot(received), title('Ideally Received Signals (Noise Free)');
axis([1 data_n -3 3]);
subplot(223);
plot(noise), title('Noise');
axis([1 data_n -3 3]);
subplot(224);
plot(polluted_received), title('Actually Received Signals (Noise Added)');
axis([1 data_n -3 3]);

%disp('Writing data ...');

training_data = zeros(data_n, 3);
training_data(:,1) = polluted_received; 
training_data(2:data_n,2) = polluted_received(1:data_n-1); 
training_data(:,3) = original;

% cut incomplete data pairs
training_data = training_data(3:data_n, :);

%save equtrain.dat training_data /ascii
