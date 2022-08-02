 p = [ 1 1 1; 1 2 -3; 2, 0, 1]
 delta = p(:,2).^2-4*p(:,1).*p(:,3)
 test = delta > 0
 sol= zeros(size(p,1),2);
 % deux racines réelles
 sol(test,1)=(-p(test,2)+sqrt(delta(test,1)))./(2*p(test,1)); 
 sol(test,2)=(-p(test,2)-sqrt(delta(test,1)))./(2*p(test,1));
 % pas de racines réelles
 sol(~test,:)= NaN