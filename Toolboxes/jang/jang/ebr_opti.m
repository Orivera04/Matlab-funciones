function out = ebr_opti(SNR)

% out = ebr(SNR) returns the error bit rate, given SNR (signal to
% noise ratio in dB)

%%%% the following is obtained from generate_data.m
leng = 1002;
rand('uniform');
transmitted = sign(2*rand(leng,1) - 1);
rand('normal');
signal_var = 1.25; 
noise_var = signal_var*10^(-SNR/10)
noise = rand(leng,1)/sqrt(1/noise_var);

received = zeros(leng,1);

for i=2:leng,
	received(i) = channel(transmitted(i), transmitted(i-1));
end
polluted_received = received + noise;

training_data = zeros(leng, 4);
training_data(:,1) = polluted_received; 
training_data(2:leng,2) = polluted_received(1:leng-1); 
training_data(:,3) = (abs(transmitted)+transmitted)/2;
training_data(:,4) = (abs(transmitted)-transmitted)/2;

% cut incomplete data pairs
training_data = training_data(3:leng, :);


%%%% the following is obtained from optimal_result.m to get p1 and p2.
order = 2;
lag = 0;
case_n = 2^(order+1);

s = zeros(case_n, order+1);

for i=1:case_n,
	tmp = dec2othe(i-1, 2);
	if length(tmp)==0
		tmp = 0;
	end
	s(i,order+2-length(tmp):order+1) = tmp;
end

s = 2*s - 1; % Elements in s is either 1 or -1.

% Channel characteristics
x1 = channel(s(:,1), s(:, 2));
x2 = channel(s(:,2), s(:, 3));

% lag
index1 = find(s(:,1+lag) > 0);
index2 = find(s(:,1+lag) < 0);

p1 = [x1(index1) x2(index1)];
p2 = [x1(index2) x2(index2)];


%%%%
covariance = noise_var*[1 0; 0 1];
inv_cov = inv(covariance);

output = f_de(training_data(:,1:2), p1, p2, inv_cov);
z = sign(output);
desired_z = training_data(:,3)-training_data(:,4);
error_bit_number = length(find(z.*desired_z < 0))
out = log10(error_bit_number/length(z));
