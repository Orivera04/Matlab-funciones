a = 0.2; b = 0.8;
[X,Y, Z] = Torus(a, b);
Lx = 0; Ly = 0; Lz = 0;
for k = 1:4
subplot(2,2,k)
switch k
case 1
mesh(X,Y,Z)
v = axis;
axis([v(1) v(2) v(3) v(4) -1 1])
text(0.5, -0.5, 1, 'Torus')
case 2
psi = 0; chi = 0; phi = pi/3;
[Xr Yr Zr] = EulerAngles(psi, chi, phi, Lx, Ly, Lz, X,Y, Z);
mesh(X,Y,Z)
hold on
mesh(Xr,Yr, Zr)
text(0.5, -0.5, 1,'\phi = 60\circ')
case 3
psi = pi/3; chi = 0; phi = 0;
[Xr Yr Zr] = EulerAngles(psi,chi,phi,Lx,Ly,Lz,X,Y,Z);
mesh(X,Y, Z)
hold on
mesh(Xr,Yr, Zr)
text(0.5,-0.5,1,'\psi = 60\circ')
case 4
psi = pi/3; chi = 0; phi = pi/3;
[Xr Yr Zr] = EulerAngles(psi,chi,phi,Lx,Ly,Lz,X,Y,Z);
mesh(X,Y, Z)
hold on
mesh(Xr,Yr, Zr)
text(0.5, -0.5, 1.35,'\psi = 60\circ')
text(0.55, -0.5, 1,'\phi = 60\circ')
end
axis equal off
grid off
colormap([0 0 0])
end
