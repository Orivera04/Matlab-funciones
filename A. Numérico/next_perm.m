function q = next_perm ( p )
%
%***********************************************************************
%
%  function q = next_perm ( p )
%
%% NEXT_PERM computes the lexicographic successor of a permutation.
%
%  Discussion:
%
%    Before calling this routine the first time, set
%
%      p = zeros ( n, 1 );
%
%    You may then make N factorial calls to this routine:
%
%      p = next_perm ( p )
%
%    and each time you will receive a new permutation.  
%    
%  Reference:
%
%    Algorithm 2.14,
%    Donald Kreher and Douglas Simpson,
%    Combinatorial Algorithms,
%
%  Modified:
%
%    01 February 2000
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, integer P(N), describes the permutation.
%    P(I) is the item which is permuted into the I-th place
%    by the permutation.  
%
%    Output, integer Q(N), describes the next permutation.  If
%    P was the very last permutation, then Q starts over with
%    the first one.
%
  n = length ( p );

  q = p;
%
%  Return the only permutation.
%
  if ( n == 1 ) 

    q = 1;
%
%  Return the first permutation.
%
  else if ( q == 0 ) 

    q = [1:n];
%
%  Return the next permutation.
%
  else
%
%  Identify the last index I for which the permutation value increases.
%
    i = n - 1;

    while ( q(i) > q(i+1) )
      i = i - 1;
      if ( i == 0 ) 
        break;
      end
    end
%
%  If no such I, we've reached the last permutation.
%
    if ( i == 0 ) 

      q = [1:n];
%
%  Seek the last index J whose permutation value is greater than I's.
%
    else

      j = n;
      while ( q(j) < q(i) )
        j = j - 1;
      end
%
%  Swap elements I and J.
%
      t = q(j);
      q(j) = q(i);
      q(i) = t;
%
%  Reverse elements I+1 through N.
%
      q(i+1:n) = q(n:-1:i+1);

    end

  end

end
