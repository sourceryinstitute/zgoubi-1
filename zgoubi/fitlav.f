C  ZGOUBI, a program for computing the trajectories of charged particles
C  in electric and magnetic fields
C  Copyright (C) 1988-2007  Fran�ois M�ot
C
C  This program is free software; you can redistribute it and/or modify
C  it under the terms of the GNU General Public License as published by
C  the Free Software Foundation; either version 2 of the License, or
C  (at your option) any later version.
C
C  This program is distributed in the hope that it will be useful,
C  but WITHOUT ANY WARRANTY; without even the implied warranty of
C  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
C  GNU General Public License for more details.
C
C  You should have received a copy of the GNU General Public License
C  along with this program; if not, write to the Free Software
C  Foundation, Inc., 51 Franklin Street, Fifth Floor,
C  Boston, MA  02110-1301  USA
C
C  Fran�ois M�ot <fmeot@bnl.gov>
C  Brookhaven National Laboratory    
C  C-AD, Bldg 911
C  Upton, NY, 11973, USA
C  -------
      FUNCTION FITLAV(L,IT1,IT2,PAR)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      INCLUDE "MAXCOO.H"
      INCLUDE "MAXTRA.H"
      LOGICAL AMQLU(5),PABSLU
      INCLUDE "C.FAISC.H"     ! COMMON/FAISC/ F(MXJ,MXT),AMQ(5,MXT),DP0(MXT),IMAX,IEX(MXT),
C     $     IREP(MXT),AMQLU,PABSLU
      DUM = PAR
      FITLAV=0.D0
      NPTS = 0
C      DO 21 I=1,IMAX
      DO 21 I=IT1, IT2
        IF(IEX(I) .LT. -1) GOTO 21
        NPTS = NPTS + 1
        FITLAV = FITLAV + F(L,I)
 21   CONTINUE
      IF(NPTS.NE.0) THEN
        FITLAV = FITLAV/NPTS
      ELSE
        FITLAV=1.D10
      ENDIF
      RETURN
      END
