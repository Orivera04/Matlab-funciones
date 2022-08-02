function Example6_4
Su = linspace(0.34, 1.72, 50); skip = [1, 3, 6, 8, 11];
ncs = NeuberData; L = length(skip);
p = polyfit(ncs(:,1), ncs(:,2), 4);
figure(1)
plot(Su, polyval(p, Su), 'k', ncs(:,1), ncs(:,2), 'ks')
xlabel('\itS_u')
ylabel('\surd\ita')
figure(2)
[s, r] = meshgrid(ncs(skip,1), linspace(0.1, 5, 80));
notch = inline('1./(1+polyval(p, s)./sqrt(r))', 'p', 's', 'r');
plot(r, notch(p, s, r), 'k')
y(1:L,1) = 1;
lab = [repmat('\itS_u= \rm', L, 1) num2str(ncs(skip,1))];
text(repmat(1, 1, L), notch(p, ncs(skip,1), y)-0.03, lab)
xlabel('\itr')
ylabel('\itq')
function nd = NeuberData
nd = [0.34, 0.66; 0.48, 0.46; 0.62, 0.36; 0.76, 0.29; 0.90, 0.23; 1.03,...
0.19;1.17, 0.14; 1.31, 0.10; 1.45, 0.075; 1.59, 0.050; 1.72, 0.036];