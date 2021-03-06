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
      FUNCTION CUBSPL(xm,ym,xv,nd,n)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      integer count
      double precision 
     >XM(nd),YM(nd),LM(nd),UM(nd),DM(nd),CM(0:nd),EM(nd)
** 
**
      cubspl = 9999.d0

      m = n - 1
      j = m - 1
      k = j - 1
**
*  GENERATION OF TRIDIAGONAL SYSTEM FOR SECOND DERIVATIVE
**
      do i = 1,j
         DM(i) = 2.d0* (XM(i+2) - XM(i))
         CM(i) = 6.d0* (YM(i+2) - YM(i+1)) / (XM(i+2) - XM(i+1)) +6.d0*
     >                         (YM(i) - YM(i+1)) / (XM(i+1) - XM(i))
      enddo
      do i = 2,j
         LM(i) = XM(i+1) - XM(i)
      enddo
      do i = 1,k
         UM(i) = XM(i+2) - XM(i+1)
      enddo
**
*  SOLUTION OF TRIDIAGONAL SYSTEM
** 
      CALL TRIDI(LM,DM,UM,CM,ND,J)
** 
**
*  EVALUATION AND PRINTING OF CUBIC SPLINES
**
      CM(0) = 0.d0
      CM(n) = 0.d0

         do 50 i = 1,m
            fact = XM(i+1) - XM(i)
            e = CM(i-1) / (6.d0*fact)
            ff = CM(i) / (6.d0*fact)
            g = (YM(i)/fact) - (CM(i-1)*fact/6.d0)
            h = (YM(i+1)/fact) - (CM(i)*fact/6.d0)
            EM(i) = e* (XM(i+1) - xv) **3 + ff* (xv - XM(i)) **3 + 
     >              g* (XM(i+1)- xv) + h* (xv - XM(i))
50       continue 
**
*  SELECTION OF APPROPRIATE SEGMENT (BASED ON THE VALUE) WHERE
*  INTERPOLATION REQUIRED
**
         count = 1
CC FM Oct 2007   60       if (xv.lt.XM(count+1)) go to 70
60       if (xv.le.XM(count+1)) go to 70
         count = count + 1
         go to 60
70       continue 
** 
**
c         write(6,*)'--------------------------------------------------'
c         write(6,71) xv,EM(count)
c71       format('0',5x,'The interpolated value at ',f6.2,' is:',f8.3)
c         write(6,*)'--------------------------------------------------'
c         write(6,*)' More Interpolation ?  < 0- for NO / 1- for YES >:'
c         read(*,*) sele
c         go to 40

        CUBSPL = EM(COUNT)
c      endif

      return
c      stop
      end
