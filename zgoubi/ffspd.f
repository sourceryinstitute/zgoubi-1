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
      FUNCTION FFSPD(XB,YB,RM,B,T,TTARF)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      SAVE EBT, COST, SINT
      EBT = EXP(B*T)
      COST=COS(TTARF+T)
      SINT=SIN(TTARF+T)
      FFSPD= 
     - (XB - EBT*RM*COST)*(B*EBT*RM*COST - EBT*RM*SINT) + 
     - (YB - EBT*RM*SINT)*(EBT*RM*COST + B*EBT*RM*SINT)
C        WRITE(*,*) ' (FFSPD) T, FFSPD = ',T, FFSPD,B,XB,YB,E,TTARF,RM
      RETURN

      ENTRY FFSPDD(XB,YB,RM,B,T,TTARF)
       FFSPDD= 
     - (B*EBT*RM*COST - EBT*RM*SINT)*(-(B*EBT*RM*COST) + EBT*RM*SINT) + 
     - (XB - EBT*RM*COST)*(-(EBT*RM*COST) + B**2*EBT*RM*COST- 
     - 2*B*EBT*RM*SINT) + (-(EBT*RM*COST) - B*EBT*RM*SINT)*
     - (EBT*RM*COST + B*EBT*RM*SINT) + (YB - EBT*RM*SINT)*
     - (2*B*EBT*RM*COST - EBT*RM*SINT + B**2*EBT*RM*SINT)
      RETURN
      END
