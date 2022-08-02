x = 100*rand(1,5)
explose = rand(size(x))>0.8
labels ={'1', '2', '3', '4', '5'};
subplot(1,2,1);
pie3(x, explose, labels); colormap(gray)
subplot(1,2,2)
pie(x, explose, labels); colormap(gray)