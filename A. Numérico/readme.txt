The zip file includes:
- readme.txt    ---> this file
- conv2olam.m   ---> the M-file which contains the m-function to perform 
                     Overlap-add method of CONV2 using FFT2




CONV2OLAM Overlap-add method of CONV2 using FFT2.
    Y = CONV2OLAM(A,B) performs the 2-D convolution of matrices
    A and B  using the overlap/add method and using internal parameters (FFT2
    size and block length) which guarantee efficient execution.
    If [ma,na] = size(A) and [mb,nb] = size(B), then size(Y) = [ma+mb-1,na+nb-1].
 
     
     Y = CONV2OLAM(A,B,mode,siz1,siz2) allows you to have some control over the
     internal parameters by using a zero padding. If mode is equal to:
       - 0 is the default value, if not specified. This value for
           mode uses overlap/add method. Ex. conv2olam(a,b,0) is equivalent
           to perform conv2olam(a,b).
       - 1 the dimensions of input matrices are zero padded to their nextpow2
           values (type 'help nextpow2' on Matlab prompt) to perform
           FFT2 and IFFT2. No overlap is performed. Ex. conv2olam(a,b,1)
       - 2 the dimensions of input matrices are not zero padded to perform
           these FFT-based operations. No overlap is performed. Ex. conv2olam(a,b,2)
       - 3 the dimensions of matrices are zero padded to fixed values
           which must be specified to perform overlapping.
           Ex. conv2olam(a,b,3,512,512) uses 512 X 512 matrices
           to perform overlap/add method.
  
     
     See also CONV2, FILTFILT, FFT2, IFFT2.
 
 
  Please contribute if you find this software useful.
  Report bugs to luigi.rosa@tiscali.it
 
 *****************************************************************
  Luigi Rosa
  Via Centrale 27
  67042 Civita di Bagno
  L'Aquila --- ITALY 
  email  luigi.rosa@tiscali.it
  mobile +39 340 3463208 
  http://utenti.lycos.it/matlab
 *****************************************************************
 