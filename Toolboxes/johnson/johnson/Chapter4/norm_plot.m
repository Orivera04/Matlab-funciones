function norm_plot(data)

N=length(data);
log_scores=Phiinv(((1:N)-1/3)/(N+1/3));

plot(log_scores,sort(data),'o');hold on;plot([-3 3],[-3 3],':')
xlabel('Normal scores'); ylabel('Mean latent residuals')
hold off


function val=Phiinv(x)
% Computes the standard normal quantile function of the vector x, 0<x<1.
%
val=sqrt(2)*erfinv(2*x-1);
