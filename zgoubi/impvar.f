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
CC
C  Fran�ois M�ot <fmeot@bnl.gov>
C  Brookhaven National Laboratory   
C  C-AD, Bldg 911
C  Upton, NY, 11973, USA
C  -------
      SUBROUTINE IMPVAR(IUNIT,NI)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      PARAMETER (MXV=60) 
      INCLUDE "C.CONTR.H"     ! COMMON/CONTR/VAT(MXV),XI(MXV)
      INCLUDE 'MXLD.H'
      INCLUDE "C.DON.H"     ! COMMON/DON/ A(MXL,MXD),IQ(MXL),IP(MXL),NB,NOEL
      PARAMETER (LBLSIZ=20)
      CHARACTER(LBLSIZ) LABEL
      INCLUDE "C.LABEL.H"     ! COMMON/LABEL/ LABEL(MXL,2)
      INCLUDE "C.VAR.H"     ! COMMON /VAR/ X(3*MXV),P(MXV)
      INCLUDE "C.VARY.H"  ! COMMON/VARY/ NV,IR(MXV),NC,I1(MXV),I2(MXV),V(MXV),IS(MXV),W(MXV),
                          !     >IC(MXV),IC2(MXV),I3(MXV),XCOU(MXV),CPAR(MXV,27)
      INCLUDE 'MXFS.H'
      PARAMETER (KSIZ=10)
      CHARACTER(KSIZ) FAM ; CHARACTER(LBLSIZ) LBF
      INCLUDE "C.SCALT.H"     ! COMMON/SCALT/ FAM(MXF),LBF(MXF,MLF)
      CHARACTER(KSIZ) KLE
      CHARACTER(LBLSIZ) LBL1, LBL2
      LOGICAL EMPTY
      LOGICAL NOSYS,NOSYSI,NSYS,NSYSI
      SAVE NOSYS,NSYS

      DATA NSYS, NOSYS / .FALSE. , .FALSE. /
    
      IF(NSYS) THEN
        RETURN
      ENDIF     

      CALL MINO13(
     >            NITER)
      IF(IUNIT .EQ. 7) WRITE(IUNIT,100)
100   FORMAT('1')
      IF(IUNIT.GT.0) WRITE(IUNIT,200) NI, NITER
200   FORMAT(/,' STATUS OF VARIABLES  (Iteration #',I6,
     >' / ',I6,' max.)')
      IF(IUNIT.GT.0) WRITE(IUNIT,300)
300   FORMAT(
     >'LMNT VAR PARAM  MINIMUM    INITIAL         FINAL        ',
C----- IR(I)  I IS(I)    X(K)       XI(I)          X(I)  
     >' MAXIMUM     STEP        NAME   LBL1                 LBL2' )
C----    X(J)       P(I)
 
      DO 1 I=1,NV
        K=I+NV
        J=K+NV
        CALL ZGKLE(IQ(IR(I))
     >                      ,KLE)
        LBL1 = LABEL(IR(I),1)
        LBL2 = LABEL(IR(I),2)
        IF(EMPTY(LBL1)) LBL1 = '-'
        IF(EMPTY(LBL2)) LBL2 = '-'
        IF(IUNIT.GT.0) WRITE(IUNIT,400) IR(I),I,IS(I),X(K),XI(I),
     >  A(IR(I),IS(I)),X(J),P(I),KLE,LBL1,LBL2
 400    FORMAT(1P, 
     >  I4,2X,I2,3X,I3,2(2X,G10.3),1X,G15.8,2(1X,G10.3),1X,3(1X,A))
        IF(XCOU(I).NE.0.D0) THEN
C          KL=XCOU(I)
          KL=INT( XCOU(I) )
          KP=NINT((1D3*XCOU(I)-1D3*KL))
          SGN = dsign(1.d0,dble(KL))
          ISGN = NINT(SGN)
          IF    (ISGN .EQ. 1) THEN
            XMI = X(K)
            XINI = XI(I)
            XMA = X(J)
          ELSEIF(ISGN .EQ. -1) THEN
            SGN= DSIGN(1.D0,A(IR(I),IS(I)))* 
     >                            DSIGN(1.D0,A(ISGN*KL,ISGN*KP))
            JSGN = NINT(SGN)
            IF   (JSGN .EQ. 1) THEN
              XMI = X(K)
              XINI = XI(I)
              XMA = X(J)
            ELSEIF(JSGN .EQ. -1) THEN
              XMI = -X(J)
              XINI = -XI(I)
              XMA = -X(K)
            ELSE
              CALL ENDJOB('Pgm impvar. Impossible value JSGN =',JSGN)
            ENDIF
          ELSE
            CALL ENDJOB('Pgm impvar. Impossible value ISGN =',ISGN)
          ENDIF
          IF(IUNIT.GT.0) WRITE(IUNIT,400) 
     >    ISGN*KL,I,ISGN*KP,xmi,xini,
     >    A(ISGN*KL,ISGN*KP),xma,P(I)
        ENDIF
 1    CONTINUE
      IF(IUNIT.GT.0) CALL FLUSH2(IUNIT,.FALSE.)

      NSYS = NOSYS

      RETURN

      ENTRY IMPVA2(NOSYSI,NSYSI)
      NOSYS = NOSYSI
      NSYS = NSYSI
      RETURN
      END
