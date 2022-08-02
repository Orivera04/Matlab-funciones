function vrr=proptet(v,x1,y1,z1,x2,y2,z2,...
                     x3,y3,z3,xc,yc,zc)
%                   
% vrr=proptet(v,x1,y1,z1,x2,y2,z2,x3,y3,z3,...
%                                    xc,yc,zc)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes tensor properties of a
% tetrahedron with its base being a triangular
% surface and its apex at the origin
vrr=tensprod(v,x1,y1,z1)+tensprod(v,x2,y2,z2)+...
    tensprod(v,x3,y3,z3)+tensprod(v,xc,yc,zc);