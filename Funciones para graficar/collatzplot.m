function collatzplot(n)
% Plot length of sequence for Collatz problem
% Prepare figure
clf
set(gcf,'DoubleBuffer','on')
set(gca,'XScale','linear')
%
% Determine and plot sequence and sequeence length
for m = 1:n
    plot_seq = collatz(m);
    seq_length(m) = length(plot_seq);
    line(m,seq_length(m),'Marker','.','MarkerSize',9,'Color','blue')
    drawnow
end