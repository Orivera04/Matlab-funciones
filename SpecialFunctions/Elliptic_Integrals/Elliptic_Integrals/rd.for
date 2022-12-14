     DOUBLE PRECISION FUNCTION RD(X,Y,Z,ERRTOL,IERR)
C
C          THIS FUNCTION SUBROUTINE COMPUTES AN INCOMPLETE ELLIPTIC
C          INTEGRAL OF THE SECOND KIND,
C          RD(X,Y,Z) = INTEGRAL FROM ZERO TO INFINITY OF
C
C                                -1/2     -1/2     -3/2
C                      (3/2)(T+X)    (T+Y)    (T+Z)    DT,
C
C          WHERE X AND Y ARE NONNEGATIVE, X + Y IS POSITIVE, AND Z IS
C          POSITIVE.  IF X OR Y IS ZERO, THE INTEGRAL IS COMPLETE.
C          THE DUPLICATION THEOREM IS ITERATED UNTIL THE VARIABLES ARE
C          NEARLY EQUAL, AND THE FUNCTION IS THEN EXPANDED IN TAYLOR
C          SERIES TO FIFTH ORDER.  REFERENCE: B. C. CARLSON, COMPUTING
C          ELLIPTIC INTEGRALS BY DUPLICATION, NUMER. MATH. 33 (1979),
C          1-16.  CODED BY B. C. CARLSON AND ELAINE M. NOTIS, AMES
C          LABORATORY-DOE, IOWA STATE UNIVERSITY, AMES, IOWA 50011.
C          MARCH 1, 1980..
C
C          CHECK: RD(X,Y,Z) + RD(Y,Z,X) + RD(Z,X,Y)
C          = 3 / DSQRT(X * Y * Z), WHERE X, Y, AND Z ARE POSITIVE.
C
      INTEGER IERR,PRINTR
      DOUBLE PRECISION C1,C2,C3,C4,EA,EB,EC,ED,EF,EPSLON,ERRTOL,LAMDA
      DOUBLE PRECISION LOLIM,MU,POWER4,SIGMA,S1,S2,UPLIM,X,XN,XNDEV
      DOUBLE PRECISION XNROOT,Y,YN,YNDEV,YNROOT,Z,ZN,ZNDEV,ZNROOT
C          INTRINSIC FUNCTIONS USED: DABS,DMAX1,DMIN1,DSQRT
C
C          PRINTR IS THE UNIT NUMBER OF THE PRINTER.
      DATA PRINTR/6/
C
C          LOLIM AND UPLIM DETERMINE THE RANGE OF VALID ARGUMENTS.
C          LOLIM IS NOT LESS THAN 2 / (MACHINE MAXIMUM) ** (2/3).
C          UPLIM IS NOT GREATER THAN (0.1 * ERRTOL / MACHINE
C          MINIMUM) ** (2/3), WHERE ERRTOL IS DESCRIBED BELOW.
C          IN THE FOLLOWING TABLE IT IS ASSUMED THAT ERRTOL WILL
C          NEVER BE CHOSEN SMALLER THAN 1.D-5.
C
C          ACCEPTABLE VALUES FOR:   LOLIM      UPLIM
C          IBM 360/370 SERIES   :   6.D-51     1.D+48
C          CDC 6000/7000 SERIES :   5.D-215    2.D+191
C          UNIVAC 1100 SERIES   :   1.D-205    2.D+201
C
C          WARNING: IF THIS PROGRAM IS CONVERTED TO SINGLE PRECISION,
C          THE VALUES FOR THE UNIVAC 1100 SERIES SHOULD BE CHANGED TO
C          LOLIM = 1.E-25 AND UPLIM = 2.E+21 BECAUSE THE MACHINE
C          EXTREMA CHANGE WITH THE PRECISION.
C
      DATA LOLIM/6.D-51/, UPLIM/1.D+48/
C
C          ON INPUT:
C
C          X, Y, AND Z ARE THE VARIABLES IN THE INTEGRAL RD(X,Y,Z).
C
C          ERRTOL IS SET TO THE DESIRED ERROR TOLERANCE.
C          RELATIVE ERROR DUE TO TRUNCATION IS LESS THAN
C          3 * ERRTOL ** 6 / (1-ERRTOL) ** 3/2.
C
C          SAMPLE CHOICES:  ERRTOL   RELATIVE TRUNCATION
C                                    ERROR LESS THAN
C                           1.D-3    4.D-18
C                           3.D-3    3.D-15
C                           1.D-2    4.D-12
C                           3.D-2    3.D-9
C                           1.D-1    4.D-6
C
C          ON OUTPUT:
C
C          X, Y, Z, AND ERRTOL ARE UNALTERED.
C
C          IERR IS THE RETURN ERROR CODE:
C               IERR = 0 FOR NORMAL COMPLETION OF THE SUBROUTINE,
C               IERR = 1 FOR ABNORMAL TERMINATION.
C
C          ********************************************************
C          WARNING: CHANGES IN THE PROGRAM MAY IMPROVE SPEED AT THE
C          EXPENSE OF ROBUSTNESS.
C
      IF (DMIN1(X,Y) .LT. 0.D0) GO TO 100
      IF (DMIN1(X+Y,Z) .LT. LOLIM) GO TO 100
      IF (DMAX1(X,Y,Z) .LE. UPLIM) GO TO 112
  100 WRITE(PRINTR,104)
  104 FORMAT(1H0,42H*** ERROR - INVALID ARGUMENTS PASSED TO RD)
      WRITE(PRINTR,108) X,Y,Z
  108 FORMAT(1H ,4HX = ,D23.16,4X,4HY = ,D23.16,4X,4HZ = ,D23.16)
      IERR = 1
      GO TO 124
C
  112 IERR = 0
      XN = X
      YN = Y
      ZN = Z
      SIGMA = 0.D0
      POWER4 = 1.D0
C
  116 MU = (XN + YN + 3.D0 * ZN) * 0.2D0
      XNDEV = (MU - XN) / MU
      YNDEV = (MU - YN) / MU
      ZNDEV = (MU - ZN) / MU
      EPSLON = DMAX1(DABS(XNDEV),DABS(YNDEV),DABS(ZNDEV))
      IF (EPSLON .LT. ERRTOL) GO TO 120
      XNROOT = DSQRT(XN)
      YNROOT = DSQRT(YN)
      ZNROOT = DSQRT(ZN)
      LAMDA = XNROOT * (YNROOT + ZNROOT) + YNROOT * ZNROOT
      SIGMA = SIGMA + POWER4 / (ZNROOT * (ZN + LAMDA))
      POWER4 = POWER4 * 0.25D0
      XN = (XN + LAMDA) * 0.25D0
      YN = (YN + LAMDA) * 0.25D0
      ZN = (ZN + LAMDA) * 0.25D0
      GO TO 116
C
  120 C1 = 3.D0 / 14.D0
      C2 = 1.D0 / 6.D0
      C3 = 9.D0 / 22.D0
      C4 = 3.D0 / 26.D0
      EA = XNDEV * YNDEV
      EB = ZNDEV * ZNDEV
      EC = EA - EB
      ED = EA - 6.D0 * EB
      EF = ED + EC + EC
      S1 = ED * (- C1 + 0.25D0 * C3 * ED - 1.5D0 * C4 * ZNDEV * EF)
      S2 = ZNDEV * (C2 * EF + ZNDEV * (- C3 * EC + ZNDEV * C4 * EA))
      RD = 3.D0 * SIGMA + POWER4 * (1.D0 + S1 + S2) / (MU * DSQRT(MU))
C
  124 RETURN
      END
