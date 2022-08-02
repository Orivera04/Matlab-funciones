for i = 5:-1:0
  cn = num2str(i); 
  j = inline(['besselj(' cn ', x)'], 'x');
  ezplot(j, [0, 10]);
  hold on
end;
title('Fonctions J_0 à J_5 sur [0 10]', 'fontsize', 12)