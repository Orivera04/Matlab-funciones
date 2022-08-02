function outc = addcomp(z1, z2)
% addcomp adds two complex numbers z1 and z2 & returns the result
% Adds the real and imaginary parts separately
% Format: addcomp(z1,z2)

realpart = real(z1) + real(z2);
imagpart = imag(z1) + imag(z2);
outc = realpart + imagpart * 1i;
end
