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
C  Upton, NY, 11973
C  USA
C  -------
      FUNCTION OKKP3(KP1,KP2,KP3,IPASS,
     >                                IEND)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      LOGICAL OKKP3
      OKKP3=.FALSE.
      IEND=0
      IF(KP1 .GE. 0) THEN
        IF(IPASS.GE.KP1  .AND. IPASS.LE.KP2) THEN   
          IF(MOD(IPASS-KP1,KP3) .EQ. 0) THEN
            OKKP3=.TRUE.
          ENDIF
        ELSEIF(IPASS.GT.KP2) THEN
C--------- Data reading will end
          IEND=1
        ENDIF  
      ELSEIF(KP1 .EQ. -1)  THEN
C--------- Plot at [KP2]-ipass
        IF((IPASS/KP2)*KP2 .EQ. IPASS) THEN
          OKKP3=.TRUE.
        ENDIF
      ENDIF
      RETURN
      END
