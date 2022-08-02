% Plot the partition function

t = PartitionTable(50);
x = t(:,1);
y = t(:,2);

figure;
semilogy(x,y),
    xlabel('n'),...
    ylabel('p(n)'),title('Unrestricted partition function')
grid on;
