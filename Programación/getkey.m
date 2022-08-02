function key = getkey(password)
%GETKEY: key = getkey(password)
% Converts a string into a key for use
% in the encrypt and decrypt functions.
% Uses triple DES.
import javax.crypto.spec.*
b = int8(password) ;
n = length(b) ;
b((n+1):24) = 0 ;
b = b(1:24) ;
key = SecretKeySpec(b, 'DESede') ;
