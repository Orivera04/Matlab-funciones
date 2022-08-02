%	Diagrammatic solution to generalized modus tollens (GMT).

%	Copyright by Jyh-Shing Roger Jang, 6-2-93.
%	(Tested on Matlab version 4.0a, HP workstation)
%	(Tested on Matlab version 3.5e, DEC 5000)

b = (0:0.025:1)';
a = (0:0.2:1)';
axis('square');
axis([0 1 0 1]);
tmp = zeros(length(b), length(a));

clf; subplot(221);
for i=1:length(a),
	tmp(:,i) = min(b, a(i)); 
end
plot(b, tmp); xlabel('b'); ylabel('h'); title('(a) h = min(a, b)');
axis square
text(1.02, 0.16, 'a=0.2');
text(1.02, 0.36, 'a=0.4');
text(1.02, 0.56, 'a=0.6');
text(1.02, 0.76, 'a=0.8');
text(1.02, 0.96, 'a=1.0');
b_prime = [1-b  1-b.*b 1-b.^(0.5)  b];
subplot(222); axis([0 1 0 1]); plot(b, min(b_prime(:,1)*ones(1,6), tmp), ':');
axis square
xlabel('b'); ylabel('h'); title('(b) B'' = not B');
hold on; plot(b, b_prime(:,1), '-'); hold off;
subplot(223); axis([0 1 0 1]); plot(b, min(b_prime(:,2)*ones(1,6), tmp), ':');
axis square
xlabel('b'); ylabel('h'); title('(c) B'' = not very B');
hold on; plot(b, b_prime(:,2), '-'); hold off;
subplot(224); axis([0 1 0 1]); plot(b, min(b_prime(:,3)*ones(1,6), tmp), ':');
axis square
xlabel('b'); ylabel('h'); title('(d) B'' = not more or less B');
hold on; plot(b, b_prime(:,3), '-'); hold off;

pp;

clf; subplot(221);
for i=1:length(a),
	tmp(:,i) = b.*a(i); 
end
plot(b, tmp); xlabel('b'); ylabel('h'); title('(a) h = a*b');
axis square
text(1.02, 0.16, 'a=0.2');
text(1.02, 0.36, 'a=0.4');
text(1.02, 0.56, 'a=0.6');
text(1.02, 0.76, 'a=0.8');
text(1.02, 0.96, 'a=1.0');
b_prime = [1-b  1-b.*b 1-b.^(0.5)  b];
subplot(222); axis([0 1 0 1]); plot(b, min(b_prime(:,1)*ones(1,6), tmp), ':');
axis square
xlabel('b'); ylabel('h'); title('(b) B'' = not B');
hold on; plot(b, b_prime(:,1), '-'); hold off;
subplot(223); axis([0 1 0 1]); plot(b, min(b_prime(:,2)*ones(1,6), tmp), ':');
axis square
xlabel('b'); ylabel('h'); title('(c) B'' = not very B');
hold on; plot(b, b_prime(:,2), '-'); hold off;
subplot(224); axis([0 1 0 1]); axis([0 1 0 1]); plot(b, min(b_prime(:,3)*ones(1,6), tmp), ':');
axis square
xlabel('b'); ylabel('h'); title('(d) B'' = not more or less B');
hold on; plot(b, b_prime(:,3), '-'); hold off;

pp;

clf; subplot(221);
for i=1:length(a),
	tmp(:,i) = min(1, 1-b+a(i)); 
end
plot(b, tmp); xlabel('b'); ylabel('h'); title('(a) h = min(1, 1-a+b)');
axis square
text(1.02, 0.16, 'a=0.2');
text(1.02, 0.36, 'a=0.4');
text(1.02, 0.56, 'a=0.6');
text(1.02, 0.76, 'a=0.8');
text(1.02, 0.96, 'a=1.0');
b_prime = [1-b  1-b.*b 1-b.^(0.5)  b];
subplot(222); axis([0 1 0 1]); plot(b, min(b_prime(:,1)*ones(1,6), tmp), ':');
axis square
xlabel('b'); ylabel('h'); title('(b) B'' = not B');
hold on; plot(b, b_prime(:,1), '-'); hold off;
subplot(223); axis([0 1 0 1]); plot(b, min(b_prime(:,2)*ones(1,6), tmp), ':');
axis square
xlabel('b'); ylabel('h'); title('(c) B'' = not very B');
hold on; plot(b, b_prime(:,2), '-'); hold off;
subplot(224); axis([0 1 0 1]); plot(b, min(b_prime(:,3)*ones(1,6), tmp), ':');
axis square
xlabel('b'); ylabel('h'); title('(d) B'' = not more or less B');
hold on; plot(b, b_prime(:,3), '-'); hold off;

pp;

clf; subplot(221);
for i=1:length(a),
	tmp(:,i) = max(min(b, a(i)), 1-b);
end
plot(b, tmp); xlabel('b'); ylabel('h'); title('(a) h = max(min(a, b), 1-a)');
axis square
text(1.02, 0.16, 'a=0.2');
text(1.02, 0.36, 'a=0.4');
text(1.02, 0.56, 'a=0.6');
text(1.02, 0.76, 'a=0.8');
text(1.02, 0.96, 'a=1.0');
b_prime = [1-b  1-b.*b 1-b.^(0.5)  b];
subplot(222); axis([0 1 0 1]); plot(b, min(b_prime(:,1)*ones(1,6), tmp), ':');
axis square
xlabel('b'); ylabel('h'); title('(b) B'' = not B');
hold on; plot(b, b_prime(:,1), '-'); hold off;
subplot(223); axis([0 1 0 1]); plot(b, min(b_prime(:,2)*ones(1,6), tmp), ':');
axis square
xlabel('b'); ylabel('h'); title('(c) B'' = not very B');
hold on; plot(b, b_prime(:,2), '-'); hold off;
subplot(224); axis([0 1 0 1]); plot(b, min(b_prime(:,3)*ones(1,6), tmp), ':');
axis square
xlabel('b'); ylabel('h'); title('(d) B'' = not more or less B');
hold on; plot(b, b_prime(:,3), '-'); hold off;

