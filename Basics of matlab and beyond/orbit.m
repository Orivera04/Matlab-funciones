function orbit(N)

if nargin==0
  N = 50;
end
[az el] = view;
rotvec = linspace(0,360,N);
for i=1:N
  view([az+rotvec(i) el])
  drawnow
end
