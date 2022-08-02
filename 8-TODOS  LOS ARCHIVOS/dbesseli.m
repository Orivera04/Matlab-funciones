function  w = dbesseli(nu,z,scale)
if nargin == 2, scale = 0; end
if nu==0
    w=besseli(1,z)
else
    w=0.5.*(besseli(nu-1,z)+besseli(nu+1,z));
end


