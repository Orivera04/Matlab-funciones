function display(int)
% © Dunay Rezs"o 1998; program az Uj adattipusok c. reszhez
% INTERVAL/DISPLAY intervallum objektum ki\a'{\i}rat\a'asa a
% k\a'eperny\H ore

[n,m]=size(int.l);
for i=1:n
 for j=1:m
  fprintf('\%f \%f ',int.l(i,j),int.u(i,j));
 end
fprintf('\n');
end