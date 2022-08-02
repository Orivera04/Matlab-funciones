function t = decrypt(e, key)
%DECRYPT: t = decrypt(e, key)
% Decrypt the encrypted byte array e
% into to plaintext string t using a key
% from getkey.
import javax.crypto.*
cipher = Cipher.getInstance('DESede') ;
cipher.init(Cipher.DECRYPT_MODE, key) ;
t = char(cipher.doFinal(e))' ;
