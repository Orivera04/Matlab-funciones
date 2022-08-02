
				     MATLAB toolbox
		________________________________________________________

				 Single precision class
		________________________________________________________


** Contents

	1. Introduction
	2. Requirements
	3. Installation
	4. Comments
	5. Copyright
	6. Warranty
	7. History
	8. Download
	9. Trademarks

** Publisher

	Marcel Leutenegger		marcel.leutenegger@epfl.ch
	EPFL STI IOA LOB
	BM 4.143			Tel:	+41 21 693 77 19
	Station 17
	CH-1015 Lausanne



1. Introduction

	Single precision floating point numbers reduce memory consumption by 50% com-
	pared to the default double precision numbers. In addition, the processing time
	is reduced by up to 50%. Single precision numbers are a primitive data type in
	MATLAB. Array indexing and permutation, sorting and comparisons are supported
	as for any primitive data type. However, MATLAB has no built-in math support.
	This package contains a collection of the most basic math operations enabling
	to calculate with single precision numbers in MATLAB.


2. Requirements

	• An Intel-based computer architecture with an Pentium II or better processor.
	• MATLAB 6.0 or newer running.
	• Need for speed :-)


3. Installation

	Unpack the archive in a folder that is part of the MATLAB path.

	The subfolder '@double' contains libraries that directly overload some built-in
	functions. "single" returns an empty single array if called without any input
	argument, which is needed for accessing single precision constants. The other
	functions are constants used with the fast Fourier transform kernel. Please
	look at "sfftw" for detailed information.

	The subfolder '@single' contains libraries supporting single precision math ope-
	rations. All elementary math operations as well as the matrix product are provi-
	ded. However, other matrix operations are currently delegated to the built-in
	double precision operations.


4. Comments

	Do not rename the subfolders for making sure that the functions are called for
	the correct data type. If not needed, the functions do not check the data type
	of passed arguments.

   Accuracy

	The results of the single precision functions slightly differ from the built-in
	functions. On one hand, the accuracy of complex elementary functions benefits from
	the floating-point registers with a 64bit mantissa on Intel processors. Intermediate
	values are kept in floating-point registers such that rounding takes place mostly
	once. On the other hand, the rounding error is larger due to the 24bit mantissa of
	single precision numbers.

	In general, a statement of "inverseFunction(function(value))" produces "value" with
	a relative error of less than 1.0E-5. The roundoff error of about 1.2E-8 leads to
	relatively important deviations in exponentiation. Note also that in particular
	addition/subtraction in the argument of a logarithm are critical operations due to
	a relative amplification of the rounding error. The logarithm itself works accurate
	over the full complex plane R x iR. For the sake of performance, the inverse trans-
	cendental functions are currently not implemented in that way. See also the summary
	about complex functions.

   Constants

	The class provides access to single precision constants. For a built-in function,
	MATLAB calls always the double precision function whenever no input argument is
	given. To get a single precision constant, use:

		pi(single)		pi
		eps(single)		1.19E-8
		ones(single)		1
		realmax(single)		3.40E+38
		realmin(single)		1.18E-38
		zeros(single)		0

		rand(single)		uniformly distributed random number
		randn(single)		normally distributed random number


    Transcendental functions: pi

	For periodic transcendental functions, the constant 2*pi is truncated to a 24bit
	mantissa. This guarantees that a statement of the form "sin(x)" with real "x" always
	produces the expected value "sin(rem(x,2*pi))" at the same accuracy. The reminder is
	always computed explicitly and prescaled to a 64bit mantissa.

	Example 1:

		x=pow2(pi,0:256);
		plot(x,builtin('sin',x),'r',x,sin(x),'b');
		set(gca,'XScale','log');

    Matrix product

	The matrix product was manually implemented instead of using the ATLAS package. The
	performance is higher on small matrices, comparable on medium sized matrices and about
	10% slower on very large matrices. The main advantage of the manual implementation is
	its small size of 23kBytes instead of at least 500kBytes with ATLAS.


5. Copyright

	These routines are published as freeware. The author reserves the right to modify
	any of the contained files.

	You are allowed to distribute this package as long as you deliver for free the entire,
	original package.

		Path		Files

		/		Readme.txt
		@double/	fftwBackward.m		fftwBelievePcost.m	fftwComments.m
				fftwConserveMemory.m	fftwContents.m		fftwDestroyInput.m
				fftwEstimate.m		fftwEstimatePatient.m	fftwExhaustive.m
				fftwForward.m		fftwMeasure.m		fftwPatient.m
				fftwPreserveInput.m	single.dll		single.m
		@single/	_colonobj.m		abs.dll			acos.dll
				acosh.dll		and.dll			angle.dll
				asin.dll		asinh.dll		atan.dll
				atan2.dll		atanh.dll		ceil.dll
				cis.dll			cis.m			colon.dll
				complex.dll		conj.dll		cos.dll
				cosh.dll		cot.m			coth.m
				cumprod.m		cumsum.m		det.m
				diff.m			eps.dll			eq.dll
				exp.dll			fft.m			fft2.m
				fftn.m			fix.dll			floor.dll
				fprintf.m		full.m			ge.dll
				gt.dll			ifft.m			ifft2.m
				ifftn.m			inv.m			isfinite.dll
				isinf.dll		isnan.dll		ldivide.dll
				le.dll			log.dll			log2.dll
				log10.dll		lt.dll			minus.dll
				mldivide.m		mod.dll			mpower.m
				mrdivide.m		mtimes.dll		ne.dll
				norm.m			not.dll			ones.dll
				or.dll			pi.dll			plus.dll
				pow2.dll		power.m			prod.dll
				rand.m			randn.m			rdivide.dll
				realmax.m		realmin.m		rem.dll
				round.dll		sfftw.dll		sfftw.m
				sing.dll		sin.dll			single.dll
				single.m		sinh.dll		sort.m
				sprintf.m		sqrt.dll		sum.m
				svd.m			tan.dll			tanh.dll
				times.dll		uminus.dll		uplus.dll
				xor.dll			zeros.dll


6. Warranty

	Any warranty is strictly refused and you cannot anticipate any financial or
	technical support in case of malfunction or damage.

	Feedback and comments are welcome. I will try to track reported problems and
	fix bugs.


7. History

   • December 29, 2005
	Initial release.


8. Download

	Optimized MATLAB routines are available online at:

		   http://ioalinux1.epfl.ch/~mleutene/MATLABToolbox/


	A summary is also published at MATLAB central:

			http://www.mathworks.com/matlabcentral/


9. Trademarks

	MATLAB is a registered trademark of The MathWorks, Inc. Pentium II is a
	registered trademark of Intel Corporation. Other product or brand names
	are trademarks or registered trademarks of their respective holders.

		________________________________________________________

			    Site map • EPFL © 2005, Lausanne
			      Webmaster • 29 December 2005
