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
      SUBROUTINE NORMB(SCAL,BRI,
     >                          B,DB,DDB)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      DIMENSION B(5,*),DB(3,*),DDB(3,3,*)
      FAC = SCAL*BRI
      DO 1 I=1,3
        B(1,I)=B(1,I)*FAC
        DO 1 J=1,3
          DB(I,J)=DB(I,J)*FAC
          DO 1 K=1,3
            DDB(I,J,K)=DDB(I,J,K)*FAC
 1    CONTINUE
      RETURN
      END
