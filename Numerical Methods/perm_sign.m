function p_sign = perm_sign ( p )
%
%  function p_sign = perm_sign ( p )
%
%% PERM_SIGN returns the sign of a permutation.
%
%
%  Discussion:
%
%    A permutation can always be replaced by a sequence of pairwise
%    transpositions.  A given permutation can be represented by
%    many different such transposition sequences, but the number of
%    such transpositions will always be odd or always be even.
%    If the number of transpositions is even or odd, the permutation is
%    said to be even or odd.
%
%  Example:
%
%    Input:
%
%      P = 2, 3, 9, 6, 7, 8, 5, 4, 1
%
%    Output:
%
%      P_SIGN = +1
%
%  Reference:
%
%    A Nijenhuis and H Wilf,
%    Combinatorial Algorithms,
%    Academic Press, 1978, second edition,
%    ISBN 0-12-519260-6.
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
%    The object in position I was permuted to position P(I).
%
%    Output, integer P_SIGN, the "sign" of the permutation.
%    +1, the permutation is even,
%    -1, the permutation is odd.
%
  n = length ( p );

  p_sign = 1;
%
%  Put each item 1 through N-1 back in its original position.
%
  for i = 1 : n-1
%
%  J is the current position of item I.
%
    j = i;

    while ( p(j) ~= i )
      j = j + 1;
    end
%
%  Unless the item is already in the correct place, restore it.
%
    if ( j ~= i )

      temp = p(i);
      p(i) = p(j);
      p(j) = temp;

      p_sign = - p_sign;

    end

  end
