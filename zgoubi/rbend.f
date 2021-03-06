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
      SUBROUTINE RBEND(ND)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
C     ****************************
C     READS DATA FOR BEND
C     ****************************
      INCLUDE "C.CDF.H"     ! COMMON/CDF/ IES,LF,LST,NDAT,NRES,NPLT,NFAI,NMAP,NSPN,NLOG
      INCLUDE 'MXLD.H'
      INCLUDE "C.DON.H"     ! COMMON/DON/ A(MXL,MXD),IQ(MXL),IP(MXL),NB,NOEL
 
      CHARACTER(132) TXT132
      CHARACTER(30) STRA(6)
      INTEGER DEBSTR
      LOGICAL STRCON

      READ(NDAT,*) IA
      A(NOEL,1) = IA
C     ... XL, SKEW ANGLE, BO, G, G'
C      READ(NDAT,*) (A(NOEL,I),I=10,12)
      READ(NDAT,FMT='(A)') TXT132 
      IF(STRCON(TXT132,'!',
     >                     IS)) 
     >TXT132 = TXT132(DEBSTR(TXT132):IS-1)
      CALL STRGET(TXT132,6
     >                    ,MSS,STRA)
      DO I = 1, MSS
        READ(STRA(I),*) A(NOEL,9+I)
      ENDDO

C     ... XE, LE, WE
      READ(NDAT,*) (A(NOEL,I),I=20,22)
C      READ(NDAT,*) IA,(A(NOEL,I),I=31,36)
C      A(NOEL,30) = IA
      READ(NDAT,*) A(NOEL,30),(A(NOEL,I),I=31,36)
C     ... XS, LS, WS
      READ(NDAT,*) (A(NOEL,I),I=40,42)
C      READ(NDAT,*) IA,(A(NOEL,I),I=51,56)
C      A(NOEL,50) = IA
      READ(NDAT,*) A(NOEL,50),(A(NOEL,I),I=51,56)
 
      ND = 60
      CALL STPSIZ(NDAT,NOEL,ND,
     >                         A)

      READ(NDAT,*) IA,(A(NOEL,I),I=ND+10+1,ND+10+3)
      A(NOEL,ND+10) = IA
 
      RETURN
      END
