%Multi-precision MATLAB interface to FFTW -- Application notes.
%
%  This information is for users requesting peak performance. FFTW
%  can be tuned with little manual effort to reach top performance
%  on your particular system.
%
%  Please read first the help for a core function xfftw, where x
%  stands for single (s); double (d); or extended (e) precision.
%
%
%The computation of a discrete Fourier transform envolves basically
%three steps: (1) planning; (2) computing; and (3) gather wisdom.
%
% 1)  FFTW consists of many small hard-coded fragments optimized to
%     compute the DFT for a set of vector lengths. The planner needs
%     to determine which of these codelets should be called in which
%     order to compute the full transform fastest.
%
%     By default, the core functions xfftw request the planner to
%     estimate a good plan without actually computing the trans-
%     form. Thereby, the planner consumes little time, but returns
%     probably a sub-optimal plan. In most cases, the overall time
%     spent in planning and computing a transform is minimal.
%
%     If you need to compute a number of equal transforms sequen-
%     tially, you can optimize the plan by requesting the planner
%     to benchmark different plans for that transform. During the
%     benchmark, the input array is overwritten. Therefore, use a
%     dummy array for planning. For instance
%
%     >> xfftw(zeros(size(i)),fftwPatient+fftwPreserveInput);
%     >> o=xfftw(i);
%
%     establishes a near-optimal plan in a couple of seconds for
%     an input array i before computing the transform. The cost
%     for planning is probably higher than the time saved during
%     computation. But future transforms of the same size will
%     continue to use the near-optimal plan.
%
% 2)  The transform is computed by executing the established plan.
%
% 3)  FFTW tracks core information of established transform plans.
%     Thereby, particular transforms need be patiently benchmarked
%     once for tuning the performance of successive transforms of
%     the same array dimensions.
%
%     The core level functions attempt to load the contents of the
%     file "xfftw.wisdom" on the first transform request. The accu-
%     mulated wisdom is backed up automatically when the functions
%     are cleared from memory. Thereby, knowledge about successful
%     transforms is retained between sessions. Once you have tuned
%     a particular transform, it is automatically reused in future.
%
%
%The current interface implementation uses only the complex codlets
%of FFTW. In principle, the transform of a real array could be com-
%puted faster by using the real to half-complex codelets. Though,
%the output array has to be completed for compliance with MATLAB.
%This is a simple task for 1D transforms, but it gets increasingly
%tedious for multi-dimensional transforms, because each transformed
%dimension has to be post-processed.
%
%
%Refer to the FFTW documentation for more implementation details.
%
%
%     Leutenegger Marcel © 6.8.2005
%
help fftwComments
