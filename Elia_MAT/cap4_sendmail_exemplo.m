% cap4_sendmail_exemplo
echo on
setpref('Internet','E_mail','elia_matsumoto@yahoo.com.br')
email='elia_matsumoto@yahoo.com.br';
assunto='Teste para livro';
mensagem='Email com 2 arquivos anexos';
anexos={'cap4_ftp_exemplo.m' ...
    'cap4_sendemail_exemplo.m'}
sendmail(email,assunto,mensagem,anexos)