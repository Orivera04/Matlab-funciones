A = rand(5,2);
P = inv(A'*A);
a = rand(2,1);
A = [A; a'];
P1 = inv(A'*A);
P2 = P-(P*a*a'*P)/(1+a'*P*a); 
max(max(P1-P2))

A = rand(5,2);
y = rand(5,1);
theta1 = A\y;
theta2 = zeros(2,1);
alpha = 1000000;
P = alpha*eye(2);
for i = 1:5,
	a = A(i,:)';
	P = P-(P*a*a'*P)/(1+a'*P*a); 
	theta2 = theta2 + P*a*(y(i)-a'*theta2);
end

max(theta1-theta2)
	
	 
