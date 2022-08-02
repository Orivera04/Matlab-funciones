function [npt,g1] = genbc1(npres,nx,ny)
% g1inside = 212.;
% 1outside = 70.;
% for i = 1:npres
%     if (i<=ny)
%         npt(i) = 1 + nx*(i-1);
%         g1(i) = g1inside;
%     end
%    if (i>ny)
%         npt(i) = nx*(i-ny);
%         g1(i) = g1outside;
%     end
% end
u0 = 2;
H = 2;
for i = 1:npres
    if (i<=nx)
        npt(i) = i;
        g1(i) = 0;
    end
    if (i>nx)&(i<(nx+ny-1))
        npt(i)= (i-nx)*nx+1;
        g1(i)= u0*(H/(ny-1))*(i-nx);
    end
    if (i>=(nx+ny-1))
        npt(i) = (i-(nx+ny-2))+nx*(ny-1);
        g1(i) = u0*H;
    end
end
