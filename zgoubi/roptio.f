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
C  -------
      SUBROUTINE ROPTIO
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      INCLUDE "C.CDF.H"     ! COMMON/CDF/ IES,LF,LST,NDAT,NRES,NPLT,NFAI,NMAP,NSPN,NLOG
      INCLUDE 'MXLD.H'
      INCLUDE "C.DON.H"     ! COMMON/DON/ A(MXL,MXD),IQ(MXL),IP(MXL),NB,NOEL
C      PARAMETER (LNTA=132) ; CHARACTER(LNTA) TA
C      PARAMETER (MXTA=45)
      INCLUDE "C.DONT.H"     ! COMMON/DONT/ TA(MXL,MXTA)
      LOGICAL STRCON
      CHARACTER(LNTA) TXT
      INTEGER DEBSTR, FINSTR
      PARAMETER (KSIZ=10)
      CHARACTER(KSIZ) KLE

C NY = 0/1 = off/on. NBOP = # of options, NBOP lines should follow
      LINE =1          
      READ(NDAT,*,END=90,ERR=90) NY, NBOP
      A(NOEL,1) = NY
      A(NOEL,2) = NBOP

      IF(NBOP.GT.40)
     >CALL ENDJOB('SBR roptio : nmbr of options exceded ; max is ',40)

      DO I = 1, NBOP
        LINE = LINE + 1          
        READ(NDAT,FMT='(A)',END=90,ERR=90) TXT
        TXT = TXT(DEBSTR(TXT):FINSTR(TXT))
        IF(STRCON(TXT,'!',
     >                      IS)) TXT = TXT(DEBSTR(TXT):IS-1)
        TA(NOEL,I) = TXT
      ENDDO

      RETURN

 90   CONTINUE
      CALL ZGKLEY( 
     >            KLE)
      CALL ENDJOB('*** Pgm roptio, keyword '//KLE//' : '// 
     >'input data error, at line #',LINE)
      RETURN
 
      END
