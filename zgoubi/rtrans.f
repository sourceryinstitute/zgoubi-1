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
      SUBROUTINE RTRANS
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
C     ******************************
C     READS DATA FOR MATRIX TRANSFER
C     ******************************
      INCLUDE "C.CDF.H"     ! COMMON/CDF/ IES,LF,LST,NDAT,NRES,NPLT,NFAI,NMAP,NSPN,NLOG
      INCLUDE 'MXLD.H'
      INCLUDE "C.DON.H"     ! COMMON/DON/ A(MXL,MXD),IQ(MXL),IP(MXL),NB,NOEL
      INCLUDE "C.TRNSM.H"     ! COMMON/TRNSM/ R(6,6),T(6,6,6)
 
      LINE = 1
      READ(NDAT,*,END=90,ERR=90) IORD
      A(NOEL,1) = IORD

      LINE = 2
      READ(NDAT,*,END=90,ERR=90) A(NOEL,10)

      IIB = 20
      DO 10 IA=1,6
        LINE = LINE + 1
        READ(NDAT,*,END=90,ERR=90) ( R(IA,IB), IB=1,6)
        DO 10 IB=1, 6
          A(NOEL,IIB) =  R(IA,IB)
          IIB = IIB + 1 
 10   CONTINUE

      IF(IORD .EQ. 2) THEN
        DO IA=1,6
          DO IC=1,6
C Modified, FM, 04/97
C 20         READ(NDAT,*,END=90,ERR=90) ( T(IA,IB,IC), IB=1,IC)
            LINE = LINE + 1
            READ(NDAT,*,END=90,ERR=90) ( T(IA,IB,IC), IB=1,6)
          ENDDO
        ENDDO
      ENDIF
 
      RETURN

 90   CALL ENDJOB('*** Pgm rmcobj. Input data error, at line ',line)
      RETURN
      END
