function z = ndmtimes(x, y)
%NDMTIMES N-dimensional matrix multiply.
%
%   NDMTIMES(X, Y) is equivalent to X*Y except that the former is vectorized
%   along higher dimensions (dimensions three and above).
%
%   NDMTIMES(X) is equlvalent to NDMTIMES(X, X).
%
%   Examples
%   --------
%   In this example we want to multiply a matrix X with every page (2-D slice)
%   of a 3-D array Y.
%
%      X = randn(4, 3);
%      Y = randn(3, 5, 7);
%
%      % the way to do it with a loop
%      Z1 = zeros(4, 5, 7);
%      for i = 1:7
%         Z1(:,:,i) = X(:,:) * Y(:,:,i);
%      end
%
%      % this does it without a loop
%      Z2 = ndmtimes(X, Y);
%
%   In the following example X is a 4-D array and Y is a 5-D array.  Every page
%   in X is multiplied with the corresponding page in Y.  Scalar expansion is
%   done along singleton dimensions (dimension 5 in X and dimension 4 in Y).
%
%      X = randn(4, 3, 6, 7, 1);
%      Y = randn(3, 5, 6, 1, 5);
%
%      % the way to do it with a loop
%      Z1 = zeros(4, 5, 6, 7, 5);
%      for k = 1:5
%         for j = 1:7
%            for i = 1:6
%               Z1(:,:,i,j,k) = X(:,:,i,j,1) * Y(:,:,i,1,k);
%            end
%         end
%      end
%
%      % this does it without a loop
%      Z2 = ndmtimes(X, Y);   % Z2 will be identical to Z1.
%
%   Notes
%   -----
%   When X and Y are complex, the result might deviate a little from what a
%   loop would give.  The reason for this is that each element is computed by
%   scalar multiplication and addition rather than vector multiplication.  The
%   effect can be seen in the example
%
%      N = 5;
%      X = complex(randn(1, N), randn(1, N));
%      Y = complex(randn(N, 1), randn(N, 1));
%      Z1 = sum(X(:) .* Y(:)):
%      Z2 = X * Y:
%
%   The larger N is, the more frequently Z1 and Z2 will be different.
%
%   See also MTIMES.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-20 16:04:54 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   nargsin = nargin;
   error(nargchk(1, 2, nargsin));

   if (nargsin == 1) | isequal(x, y)

      %
      % We're computing the square of X, i.e., X * X.
      %

      % Get size of input arguments.
      sx = size(x);
      dx = ndims(x);

      i = 1:sx(1); i = i(ones(1,sx(2)),:).';
      j = 1:sx(2); j = j(ones(1,sx(1)),:);

      y = permute(x, [2, 1, 3:dx]);
      z = reshape(sum(x(i,:,:) .* y(j,:,:), 2), sx);

   else

      % Get size of input arguments.
      sx = size(x);
      sy = size(y);
      dx = ndims(x);
      dy = ndims(y);

      if dx == 2

         %
         % X is a 2D matrix.
         %

         if dy == 2

            %
            % X and Y are 2D matrices.
            %

            z = x * y;

         else

            %
            % X is a 2D matrix and Y is a 3+D array.
            %

            ny = numel(y);
            ytmp = reshape(y, [sy(1), ny/sy(1)]);
            z = reshape(x*ytmp, [sx(1), sy(2:dy)]);

         end

      else

         %
         % X is a 3+D array.
         %

         if dy == 2

            %
            % X is a 3+D array and Y is a 2D matrix.
            %

            nx = numel(x);
            xtmp = permute(x ,[1 3:dx 2]);
            xtmp = reshape(xtmp, [nx/sx(2), sx(2)]);
            z = xtmp*y;
            z = reshape(z, [sx([1 3:dx]) sy(2)]);
            z = permute(z, [1 dx 2:dx-1]);

         else

            %
            % X is a 3+D array and Y is a 3+D array.
            %

            % See if inner matrix dimensions agree.
            if sx(2) ~= sy(1)
               error('Inner matrix dimensions must agree.');
            end

            % Pad the size vectors with trailing singleton dimensions (if
            % necessary) so the vectors get the same length.
            sx = [sx, ones(1, dy-dx)];
            sy = [sy, ones(1, dx-dy)];

            % See if higher dimensions are compatible, remembering that we
            % allow expansion of singleton dimensions.
            if any(   (sx(3:end) ~= sy(3:end)) ...
                    & (sx(3:end) ~=     1    ) ...
                    & (sy(3:end) ~=     1    ))
               error('Incompatible higher dimensions.');
            end

            %
            % Now expand any singleton dimensions in either argument to
            % match the size of the other argument.
            %

            % Compute the size of "z" and the number of dimensions.
            sz = [sx(1), sy(2), max(sx(3:end), sy(3:end))];
            dz = length(sz);

            % Replicate "x" along scalar dimensions.
            xrep = sz(3:end);
            xrep(sx(3:end) == sz(3:end)) = 1;
            x = repmat(x, [1, 1, xrep]);

            % Replicate "y" along scalar dimensions.
            yrep = sz(3:end);
            yrep(sy(3:end) == sz(3:end)) = 1;
            y = repmat(y, [1, 1, yrep]);

            %
            % Now compute the product of "x" and "y".
            %

            % for speed (doesn't save much though) inline
            %
            %    [j, i] = meshgrid(1:sz(2), 1:sz(1));
            %
            i = 1:sz(1); i = i(ones(1, sz(2)),:).';
            j = 1:sz(2); j = j(ones(1, sz(1)),:);

            y = permute(y, [2, 1, 3:dz]);
            z = reshape(sum(x(i,:,:) .* y(j,:,:), 2), sz);

         end

      end

   end
