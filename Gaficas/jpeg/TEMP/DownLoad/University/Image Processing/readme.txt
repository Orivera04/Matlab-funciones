the attached utility is a work I've submitted to the university
It shows what a jpeg compression is all about.

the function implements the DCT transform, using a matrix operator.
note that matlab has a function for the DCT and iDCT transforms 
that might be more efficient.

some details of the algorithm:

	a basic jpeg compression (graylevel image):

	1) take an image (2D matrix) and devide it to 8x8 matrices
	2) for each matrix (8x8) use the DCT conversion (from the signal
	   processing toolbox). you will get an (8x8) matrix as an answer
	3) build an 8x8 matrix, which is the sum off all the matrices, such
	   that sum_matrix = A + B + C + ...
	4) sort elements of the 8x8 matrix from the highest to the smallest
	   and get the indices list.
	5) sum the last matrix with part of the elements which have the
	   higher coefficients, until you have a sufficient ratio (lets say
	   80%). for example :
	   idx = sort( sum_matrix (:) );
	   part_of_energy = sum_matrix(idx(1:20));
	   all_energy = sum_matrix(:);
	   ratio = part_of_energy/all_energy;
	6) save the partial list of indices, number of matrices (rows,lines)
	   and from each matrix from step (2) save ONLY these coefficients
	   (remember the order you save them)

	now this is the compressed data.

	to reconstract
	1) build matrices of step (2) by the zero command: A = zero(8,8); B
	   = zero(8,8); ...
	   (better to use a for loop...)
	2) in each matrix, store the coefficients in the right places, such
	   that the new A matrix is equal to the A matrix from step (2) of the
	   encoding, except for the zeros where you don't know the coefficients.
	3) for each matrix do the inverse transform (IDCT)
	4) compose these inverse-transformed matrices back into a big matrix.
	   this is the reconstracted image

	usually, you will have most of the energy inside the upper-left
	coefficient (1,1) which corresponds to the DC (or average value) of
	the whole picture.


enjoy,

Ohad Gal.