/*
 * myAD, myA2D and myMatrixAD - Automatic Differentiation of 1st and 2nd Order
 * Copyright (C) 2006 Martin Fink. (martinfink "at" gmx.at)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2.1
 * of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this library; if not, visit
 * http://www.gnu.org/licenses/gpl.html or write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
 */

Dear user,

This package can be used to calculate first and second derivatives in Matlab(TM). The respective class has to be on the search path of Matlab(TM).

Usage:
To calculate the derivatives of function myFunc at x0 you have to call
	x = myAD(x0);
	result = myFunc(x);
	functionValue = getvalues(result);
	derivatives = getderivs(result);

If (and only if) you need the second derivative, use the other provided class:
	x = myA2D(x0);
	result = myFunc(x);
	functionValue = getvalues(result);
	derivatives = getderivs(result);
	secondDerivatives = getsecderiv(result);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

At the moment you cannot use matrix product, power or division.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

It is recommended to construct solution vectors using vertcat, i.e.
	dx = [dx_1);
		dx_2;
		... etc.];
instead of
	dx(1) = dx_1;
	dx(2) = dx_2;
	... etc.
because the subscript-assignments need much more time than the vertical concatenation.

Martin Fink
June, 2006
