%	Diagrammatic solution to generalized modus ponens (GMP).

%	Copyright by Jyh-Shing Roger Jang, 6-2-93.
%	(Tested on Matlab version 4.0a, HP workstation)
%	(Tested on Matlab version 3.5e, DEC 5000)

a = (0:0.025:1)';
b = (0:0.2:1)';
axis('square');
axis([0 1 0 1]);
tmp = zeros(length(a), length(b));

clf; subplot(221);
for i=1:length(b),
	tmp(:,i) = min(a, b(i)); 
end
plot(a, tmp); xlabel('a'); ylabel('h'); title('(a) h = min(a, b)');
axis square
text(1.02, 0.16, 'b=0.2');
text(1.02, 0.36, 'b=0.4');
text(1.02, 0.56, 'b=0.6');
text(1.02, 0.76, 'b=0.8');
text(1.02, 0.96, 'b=1.0');
a_prime = [a  a.*a  a.^(0.5)  1-a];
subplot(222); plot(a, min(a_prime(:,2)*ones(1,6), tmp), ':');
axis square
xlabel('a'); ylabel('h'); title('(b) A'' = very A');
hold on; plot(a, a_prime(:,2), '-'); hold off;
subplot(223); plot(a, min(a_prime(:,3)*ones(1,6), tmp), ':');
axis square
xlabel('a'); ylabel('h'); title('(c) A'' = more or less A');
hold on; plot(a, a_prime(:,3), '-'); hold off;
subplot(224); axis([0 1 0 1]); plot(a, min(a_prime(:,4)*ones(1,6), tmp), ':');
axis square
xlabel('a'); ylabel('h'); title('(d) A'' = not A');
hold on; plot(a, a_prime(:,4), '-'); hold off;

pp;

clf; subplot(221);
for i=1:length(b),
	tmp(:,i) = a.*b(i); 
end
plot(a, tmp); xlabel('a'); ylabel('h'); title('(a) h = a*b');
axis square
text(1.02, 0.16, 'b=0.2');
text(1.02, 0.36, 'b=0.4');
text(1.02, 0.56, 'b=0.6');
text(1.02, 0.76, 'b=0.8');
text(1.02, 0.96, 'b=1.0');
a_prime = [a  a.*a  a.^(0.5)  1-a];
subplot(222); plot(a, min(a_prime(:,2)*ones(1,6), tmp), ':');
axis square
xlabel('a'); ylabel('h'); title('(b) A'' = very A');
hold on; plot(a, a_prime(:,2), '-'); hold off;
subplot(223); plot(a, min(a_prime(:,3)*ones(1,6), tmp), ':');
axis square
xlabel('a'); ylabel('h'); title('(c) A'' = more or less A');
hold on; plot(a, a_prime(:,3), '-'); hold off;
subplot(224); axis([0 1 0 1]); plot(a, min(a_prime(:,4)*ones(1,6), tmp), ':');
axis square
xlabel('a'); ylabel('h'); title('(d) A'' = not A');
hold on; plot(a, a_prime(:,4), '-'); hold off;

pp;

clf; subplot(221);
for i=1:length(b),
	tmp(:,i) = min(1, 1-a+b(i)); 
end
plot(a, tmp); xlabel('a'); ylabel('h'); title('(a) h = min(1, 1-a+b)');
axis square
text(1.02, -0.04, 'b=0.0');
text(1.02, 0.16, 'b=0.2');
text(1.02, 0.36, 'b=0.4');
text(1.02, 0.56, 'b=0.6');
text(1.02, 0.76, 'b=0.8');
a_prime = [a  a.*a  a.^(0.5)  1-a];
subplot(222); plot(a, min(a_prime(:,2)*ones(1,6), tmp), ':');
axis square
xlabel('a'); ylabel('h'); title('(b) A'' = very A');
hold on; plot(a, a_prime(:,2), '-'); hold off;
subplot(223); plot(a, min(a_prime(:,3)*ones(1,6), tmp), ':');
axis square
xlabel('a'); ylabel('h'); title('(c) A'' = more or less A');
hold on; plot(a, a_prime(:,3), '-'); hold off;
subplot(224); axis([0 1 0 1]); plot(a, min(a_prime(:,1)*ones(1,6), tmp), ':');
axis square
xlabel('a'); ylabel('h'); title('(d) A'' = A');
hold on; plot(a, a_prime(:,1), '-'); hold off;

pp;

clf; subplot(221);
for i=1:length(b),
	tmp(:,i) = max(min(a, b(i)), 1-a);
end
plot(a, tmp); xlabel('a'); ylabel('h'); title('(a) h = max(min(a, b), 1-a)');
axis square
text(1.02, -0.04, 'b=0.0');
text(1.02, 0.16, 'b=0.2');
text(1.02, 0.36, 'b=0.4');
text(1.02, 0.56, 'b=0.6');
text(1.02, 0.76, 'b=0.8');
text(1.02, 0.96, 'b=1.0');
a_prime = [a  a.*a  a.^(0.5)  1-a];
subplot(222); plot(a, min(a_prime(:,2)*ones(1,6), tmp), ':');
axis square
xlabel('a'); ylabel('h'); title('(b) A'' = very A');
hold on; plot(a, a_prime(:,2), '-'); hold off;
subplot(223); plot(a, min(a_prime(:,3)*ones(1,6), tmp), ':');
axis square
xlabel('a'); ylabel('h'); title('(c) A'' = more or less A');
hold on; plot(a, a_prime(:,3), '-'); hold off;
subplot(224); axis([0 1 0 1]); plot(a, min(a_prime(:,1)*ones(1,6), tmp), ':');
xlabel('a'); ylabel('h'); title('(d) A'' = A');
hold on; plot(a, a_prime(:,1), '-'); hold off;
axis square

