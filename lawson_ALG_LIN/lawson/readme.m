The Matlab m-files in this Toolbox are intended to be used with the Linear 
Algebra text written by Terry Lawson.  Most files use only a few lines. The 
longer ones are written in a form to be more transparent to the student, 
rather than in shortest form. 

These M-files are User Contributed Routines which are being redistributed
by The MathWorks, upon request, on an "as is" basis. A User Contributed 
Routine is not a product of The MathWorks, Inc. and The MathWorks assumes no 
responsibility for any  errors that may exist in these routines.

These files are the copyright of Terry Lawson. The user may modify these 
files for their own personal use but may not redistribute modified files 
without the written permission of Terry Lawson. For information or 
questions about these files, contact

Terry Lawson
Mathematics Department
Tulane University
New Orleans, LA 70118
tcl@math.tulane.edu

If you would like to view this information from within MATLAB, copy
the contents of the diskette into a subdirectory or folder of your
MATLAB directory or folder and make sure that the directory is on 
your MATLAB path. From within MATLAB, cd to that directory or folder
and enter  type readme  at the MATLAB prompt.

Below are the comment lines from the files in the toolbox. These comment 
lines can be obtained with the help command. The full file can be obtained
 with the type command.

%BASES4 Gives bases for four fundamental subspaces of A.
%       The command is [bnull,brange,brow,bnullat]=BASES4(A).
%       The columns of the output are the bases for the  
%       null space, range, row space, and null space of  
%       the transpose. The routine calls gauss.

%CMULT  Multiplies i-th column of A by r.
%       The command is B=CMULT(A,i,r).

%COLOP  Adds r times j-th column of A to i-th column. 
%       The command is B=COLOP(A,i,j,r).

%CPERM  Interchanges i-th and j-th columns of matrix.   
%       The command is B=CPERM(A,i,j).

%FORELIM Gives result after forward elimination.
%        It calls the routine gauss.
%        The command is [U,c]=FORELIM(A,b,tol). 
%        The optional variable tol can be adjusted 
%        to zero out small entries < tol.

%GAUSS  Does Gaussian elimination on A.
%       It find matrices U,O1,R,O with O1 A = U the 
%       matrix at the end of the forward elimination 
%       step of the Gaussian elimination algorithm, and 
%       OA = R the matrix at the end of the backward 
%       elimination step. The tolerance tol can be given
%       or left for the algorithm to determine, and 
%       entries < tol are made 0.The basic variables are 
%       given by bcol and the free variables are given 
%       by fcol. Note that there is no pivoting in this 
%       algorithm.The command is 
%       [U,O1,R,O,bcol,fcol]=GAUSS(A,tol).

%GAUSSM Shows "movie" of  Gaussian elimination.
%       The command R=GAUSSM(A) produces the 
%       reduced row echelon form of A, using pivoting 
%       only when necessary. It is a modified gauss to 
%       make it into a movie. GAUSSM(A,tol) uses the 
%       given tolerance in the rank tests. Hit the space 
%       bar to move to the next step.

%GAUSSPM Shows movie of Gaussian elimination with pivoting.
%        GAUSSPM(A,tol) uses the given tolerance in 
%        the rank tests.

%GRAM   Computes QR decomposition of A. 
%       It uses the Gram-Schmidt algorithm. 
%       The inner product is given by <x,y>=x^tBy. 
%       If B is not given it is assigned to eye(m),
%       This just gives the usual dot product.
%       The command is [Q,R]=GRAM(A,B,tol). 
%       tol is computed automatically if omitted.

%GRAMMOV Gives movie of Gram-Schmidt algorithm.
%        We start with a matrix A whose columns 
%        provide the original spanning set vi of the 
%        range of A. We compute an orthogonal basis 
%        w1,...,wr inductively, as well as the corresponding 
%        orthonormal basis q1,...,qr. The end output is 
%        Q,R so that A=QR. The command is [Q,R]=GRAMMOV(A).
%        In general Q will be an orthonormal basis for the 
%        range of A and R will give the coefficients which 
%        express the original columns of A in terms of the 
%        orthonormal basis. Q will be m by r and R will be 
%        r by n.When the columns of A are independent, R 
%        will be an invertible n by n matrix;in general, R will
%        have rank r. The intermediate output t gives the 
%        coefficients of the wi to be subtracted off to make the 
%        next vector orthogonal.

%GRAMNRM Gives orthonormal basis from orthogonal one.
%        This routine corresponds to the last step of 
%        Gram-Schmidt. The vector N is the lengths of 
%        the vectors in the columns of W and Q comes 
%        from W by making the columns unit vectors.
%        The inner product is given by <x,y>=x^tAy. If no 
%        second argument is given A is taken as eye(m), 
%        which just gives the usual dot product. The syntax 
%        is [Q,N]=GRAMNRM(W,A).

%GRAMOP  Executes one step of Gram-Schmidt algorithm.
%        This replaces the last element vk of independent  
%        vectors w1,w2,...,w(k-1),vk in R^m where the 
%        first k-1 vectors are orthogonal with wk so that 
%        all vectors are orthogonal.The matrix V has 
%        w1,...,w(k-1),vk as columns. For the usual dot 
%        product leave out the second argument and A 
%        is assigned the value eye(m). The inner product 
%        is given in terms of A by <x,y>=x^tAy. This is useful 
%        for other inner products.
%        The syntax is [W,t]=GRAMOP(V,A).

%LSOLVE Solves Ax = b using gauss.
%       This function gets the equivalent equation
%       Rx = d at the end of the Gaussian elimination algorithm  
%       by calling gauss and then either notes that there is  
%       no solution or calls rdsolve  to give a particular  
%       solution v0 and a general solution v to the homogeneous 
%       equation. The command is [v0,v]= LSOLVE(A,b,tol).

%MULT   Multiplies the i-th row by r. 
%       The command is B=MULT(A,i,r).

%NULLT  Finds null space of matrix using lsolve.
%       The  command is v = NULLT(A).

%PERM   Interchanges i-th and j-th rows of A.
%       The command is B=PERM(A,i,j).

%RDSOLVE Solves system in reduced normal form.
%        The command is [v0,v] = RDSOLVE(R,b,bcol,fcol).
%        Given a matrix A in reduced normal form, v0 is a 
%        particular solution of Ax = b,where b is a given
%        r by 1 column vector.  Here A is r by n, the zero 
%        rows having been omitted, bcol contains the basic
%        columns, and fcol contains the free columns.


%REDUCE Calls gauss to give augmented matrix in reduced form. 
%       The command is [R,d]=REDUCE(A,b,tol).

%ROWOP  Adds r times j-th row to i-th row.
%       The command is B=ROWOP(A,i,j,r). 

%SYMMOP Does one symmetric row and column operation. 
%       It puts a symmetric matrix into normal form. 
%       The syntax is [B,P]=SYMMOP(A,r).Then B=P^tAP. 
%       It is applied when the first r-1 rows and columns  
%       are in diagonal form.

%SYMMNRM Normalizes diagonal matrix.
%        It makes the diagonal entries 1,-1,0. We  
%        have P^tAP=B. The syntax is [B,P]=SYMMNRM(A).










