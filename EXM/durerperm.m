function durerperm(arg)
% DURERPERM  Permute Durer's magic square.
% Click on two different rows or columns.
% Is the result still a magic square?

if nargin == 0
   shg
   load detail
   image(X,'buttondownfcn','durerperm(''click'')')
   colormap(map)
   axis image off
   set(gca,'userdata',[])
   title('Click on two rows or columns')
elseif isequal(arg,'click')
   cp = get(gca,'currentpoint');
   a = 35;
   b = 29;
   h = 74;
   w = 75;
   p = [ceil((cp(1,1)-a)/h) ceil((cp(1,2)-b)/w)];
   if any(p < 1) || any(p > 4), return, end
   if isempty(get(gca,'userdata'))
      set(gca,'userdata',p)
   else
      p1 = get(gca,'userdata');
      p2 = p;
      Xp = get(gca,'child');
      X = get(Xp,'cdata');
      c = h*(0:3);
      d = w*(0:3);
      c([p1(2) p2(2)]) = c([p2(2) p1(2)]);
      d([p1(1) p2(1)]) = d([p2(1) p1(1)]);
      i = 0:h-1;
      j = 0:w-1;
      I = a+[c(1)+i c(2)+i c(3)+i c(4)+i];
      J = b+[d(1)+j d(2)+j d(3)+j d(4)+j];
      K = a+(0:4*h-1);
      L = b+(0:4*w-1);
      X(K,L) = X(I,J);
      set(Xp,'cdata',X)
      set(gca,'userdata',[])
   end
end
