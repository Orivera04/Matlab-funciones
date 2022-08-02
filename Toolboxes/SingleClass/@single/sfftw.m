%o=sfftw(i,f,t,s,d)
%------------------
%
%Single precision MATLAB interface to FFTW.
%
%This is the core level function exposing the guru interface of the
%discrete Fourier transform functions. The scripts FFT, IFFT, FFT2,
%IFFT2, FFTN and IFFTN provide the usual MATLAB syntax.
%
%This core function Fourier transforms a user set of dimensions in
%a single precision input array, where each transformed dimension
%can be reduced in length. Calling this function directly provides
%you with additional flexibility and improved performance.
%
%Input:
% i      Input array          (single array)
% f      Planner flags        (double scalar)   {fftwEstimate+
%                                                fftwPreserveInput}
% t      Transform type       (double scalar)   {fftwForward}
% s      Transform sizes      (double vector)   {input sizes}
% d      Transform dimensions (double vector)   {all}
%
%Output:
% o      N-dimensional (inverse) discrete Fourier transform of the
%        input array with logical sizes s of the dimensions d.
%
%Messages:
%
%* Array must be a single.
%
%     This core function only treats single precision inputs.
%
%* Option must be a double.
%
%     All options must be of type double. Imposed to prevent MATLAB
%     from calling another user object function instead.
%
%* Incompatible dimensions.
%
%     The dimension vector d and the sizes s have different length.
%
%* Invalid dimension.
%
%     A dimension was negative or larger than the number of dimen-
%     sions in input array. To transform a dimension out of scope,
%     use 'repmat' instead.
%
%* Invalid size.
%
%     A size was negative or larger than the size of the dimension.
%     The function can only reduce the length of a dimension. Use a
%     subscripted assignment to grow the array if needed. See also
%     FFTN for instance.
%
%* Dimension redefined.
%
%     A dimension was defined several times. If sizes are provided,
%     the last definition takes precedence.
%
%* Cannot do this transform.
%
%     You are Lucky Luke, aren't you. FFTW does not manage to plan
%     the transform. Probably, you provided an unsuitable planner
%     flag. If the problem persists, you may rebuild the interface
%     with all FFTW source files. This build only uses the complex
%     to complex DFT codelets.
%
%
%For more information, please refer to fftwComments.
%
%
%     Leutenegger Marcel © 4.12.2005
%