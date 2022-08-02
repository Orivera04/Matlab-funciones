data_n = 5;
data = rand(data_n, 1)+sqrt(-1)*rand(data_n, 1);
plot(data, 'o'); axis square

distance = zeros(data_n, data_n);
[xx, yy] = meshgrid(real(data), imag(data));
distance = sqrt((xx - xx').^2 + (yy - yy').^2);

