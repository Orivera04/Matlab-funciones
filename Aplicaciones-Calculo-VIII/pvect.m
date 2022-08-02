% Producto vectorial para vectores de 3D
function producto = pvect (u,v)

if length(u)~=3 | length(v)~=3
   disp('Error en las dimensiones de los vectores');
   return
else
   producto(1,1)=u(2)*v(3)-u(3)*v(2);
   producto(2,1)=u(3)*v(1)-u(1)*v(3);
   producto(3,1)=u(1)*v(2)-u(2)*v(1);
end

   
