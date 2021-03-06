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
      SUBROUTINE FITNU(LUN)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      PARAMETER (MXV=60) 
      INCLUDE "C.CONTR.H"     ! COMMON/CONTR/ VAT(MXV),XI(MXV)
      INCLUDE 'MXLD.H'
      INCLUDE "C.DON.H"     ! COMMON/DON/ A(MXL,MXD),IQ(MXL),IP(MXL),NB,NOEL
      INCLUDE "C.FINIT.H"     !COMMON/FINIT/ FINI
      INCLUDE "C.VAR.H"     ! COMMON /VAR/ X(3*MXV),P(MXV)
      INCLUDE "C.VARY.H"  ! COMMON/VARY/ NV,IR(MXV),NC,I1(MXV),I2(MXV),V(MXV),IS(MXV),W(MXV),
                          !     >IC(MXV),IC2(MXV),I3(MXV),XCOU(MXV),CPAR(MXV,27)
      EXTERNAL FF
 
      DIMENSION Y(MXV),VI(MXV)
      SAVE MTHD

      CHARACTER(80) FNAME, FNAMEI
C      SAVE LSAV, FNAME
      LOGICAL SAVFT, OK, IDLUNI
      SAVE FNAME, SAVFT

      DATA MTHD / 2 / 
      DATA LSAV / -999 /

      CALL FITEST(SAVFT,FNAME,
     >                       IER)
      IF(IER .NE. 0) CALL ENDJOB(
     >'Pgm fitnu, keyword FIT[2]. End of job upon FITEST procedure',-99)
      CALL FITSET
      CALL FITARR(IER)
      IF(IER .NE. 1) THEN
         CALL REMPLI(0)
         CALL FBORNE
         IF    (MTHD .EQ. 1) THEN
           CALL MINO1(FF,NV,X,P,VI,Y,XI,F,FINI)
         ELSEIF(MTHD .EQ. 2) THEN
C Implemented by Scott Berg, LPSC, April 2007
           CALL MINONM(NV,X,P,VI,XI,F,FINI)
         ELSE
           CALL ENDJOB('SBR fitnu, Error : no such FIT method.',-99)
         ENDIF
         CALL IMPVA2(.FALSE.,.FALSE.)
         CALL IMPCT2(.FALSE.,.FALSE.)
         CALL IMPAJU(LUN,F)
         CALL IMPAJU(6,F)
         IF(SAVFT) THEN
           IF(LSAV .LT. 0) THEN
             OK = IDLUNI(
     >                   LSAV)
             OPEN(UNIT=LSAV,FILE=FNAME)
           ENDIF
           CALL IMPAJU(LSAV,F)
C Avoid closing to ensure pile up when FIT within REBELOTE
C           CLOSE(LSAV)
         ENDIF
      ENDIF
      CALL ENDFIT
      RETURN

      ENTRY FITNU2(MTHDI) 
      MTHD = MTHDI
      RETURN

      ENTRY FITNU6(FNAMEI) 
      SAVFT = .TRUE.
      FNAME = FNAMEI
      RETURN

      END
