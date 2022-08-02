function e = encrypt(t, key)
%ENCRYPT: e = encrypt(t, key)
% Encrypt the plaintext string t into
% the encrypted byte array e using a key
% from getkey.
import javax.crypto.*
cipher = Cipher.getInstance('DESede') ;
cipher.init(Cipher.ENCRYPT_MODE, key) ;
e = cipher.doFinal(int8(t))' ;
