function matinfo(matrix)

errorflag=0;

switch matrix
case 'west0497'
   url='http://math.nist.gov/MatrixMarket/data/Harwell-Boeing/chemwest/west0497.html';
case 'watt__1'
   url='http://math.nist.gov/MatrixMarket/data/Harwell-Boeing/watt/watt__1.html';
case 'sherman2'
   url='http://math.nist.gov/MatrixMarket/data/Harwell-Boeing/sherman/sherman2.html';
case 'jpwh_991'
   url='http://math.nist.gov/MatrixMarket/data/Harwell-Boeing/cirphys/jpwh_991.html';
case 'impcol_d'
   url='http://math.nist.gov/MatrixMarket/data/Harwell-Boeing/chemimp/impcol_d.html';
case 'gre__115'
   url='http://math.nist.gov/MatrixMarket/data/Harwell-Boeing/grenoble/gre__115.html';
case 'fs_541_1'
   url='http://math.nist.gov/MatrixMarket/data/Harwell-Boeing/smtape/fs_541_1.html';
case 'BCSSTK14'
   url='http://math.nist.gov/MatrixMarket/data/Harwell-Boeing/bcsstruc2/bcsstk14.html';
case 'BCSSTK16'
   url='http://math.nist.gov/MatrixMarket/data/Harwell-Boeing/bcsstruc2/bcsstk16.html';
case 'BCSSTK26'
   url='http://math.nist.gov/MatrixMarket/data/Harwell-Boeing/bcsstruc4/bcsstk26.html';
case 'BCSSTK28'
   url='http://math.nist.gov/MatrixMarket/data/Harwell-Boeing/bcsstruc4/bcsstk28.html';
case 'BCSSTK19'
   url='http://math.nist.gov/MatrixMarket/data/Harwell-Boeing/bcsstruc3/bcsstk19.html';
case 'BCSSTK21'
   url='http://math.nist.gov/MatrixMarket/data/Harwell-Boeing/bcsstruc3/bcsstk21.html';
case 'BCSSTK22'
   url='http://math.nist.gov/MatrixMarket/data/Harwell-Boeing/bcsstruc3/bcsstk22.html';
case 'BCSSTK23'
   url='http://math.nist.gov/MatrixMarket/data/Harwell-Boeing/bcsstruc3/bcsstk23.html';
case 'BCSSTK24'
   url='http://math.nist.gov/MatrixMarket/data/Harwell-Boeing/bcsstruc3/bcsstk24.html';
case 'BCSSTM20'
   url='http://math.nist.gov/MatrixMarket/data/Harwell-Boeing/bcsstruc3/bcsstm20.html';
case 'gr_30_30'
   url='http://math.nist.gov/MatrixMarket/data/Harwell-Boeing/laplace/gr_30_30.html';
case 'nos1'
   url='http://math.nist.gov/MatrixMarket/data/Harwell-Boeing/lanpro/nos1.html';
case 'nos5'
   url='http://math.nist.gov/MatrixMarket/data/Harwell-Boeing/lanpro/nos5.html';
case 'nos7'
   url='http://math.nist.gov/MatrixMarket/data/Harwell-Boeing/lanpro/nos7.html';
case 's1rmq4m1'
   url='http://math.nist.gov/MatrixMarket/data/misc/cylshell/s1rmq4m1.html';
case 's2rmq4m1'
   url='http://math.nist.gov/MatrixMarket/data/misc/cylshell/s2rmq4m1.html';
case 'bfw398a'
   url='http://math.nist.gov/MatrixMarket/data/NEP/bfwave/bfw398a.html';
case 'bfw782a'
   url='http://math.nist.gov/MatrixMarket/data/NEP/bfwave/bfw782a.html';
case 'cavity01'
   url='http://math.nist.gov/MatrixMarket/data/SPARSKIT/drivcav_old/cavity01.html';
case 'cavity11'
   url='http://math.nist.gov/MatrixMarket/data/SPARSKIT/drivcav_old/cavity11.html';
case 'ck400'
   url='http://math.nist.gov/MatrixMarket/data/NEP/chuck/ck400.html';
case 'dw2048'
   url='http://math.nist.gov/MatrixMarket/data/NEP/dwave/dw2048.html';
case 'dwb512'
   url='http://math.nist.gov/MatrixMarket/data/NEP/dwave/dwb512.html';
case 'fs_680_1'
   url='http://math.nist.gov/MatrixMarket/data/Harwell-Boeing/facsimile/fs_680_1.html';
case 'west0067'
   url='http://math.nist.gov/MatrixMarket/data/Harwell-Boeing/chemwest/west0067.html';
case 'west0132'
   url='http://math.nist.gov/MatrixMarket/data/Harwell-Boeing/chemwest/west0132.html';   
otherwise
   disp('No Information available');
	errorflag=1;   
end

if errorflag==0
   web(url);
end
