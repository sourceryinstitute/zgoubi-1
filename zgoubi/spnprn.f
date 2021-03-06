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
      SUBROUTINE SPNPRN(KPR,NOEL,KLEY,LBL1,LBL2)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      CHARACTER(*) KLEY
      CHARACTER(*) LBL1,LBL2
      PARAMETER(MLB=10)
      INCLUDE "C.CDF.H"     ! COMMON/CDF/ IES,LF,LST,NDAT,NRES,NPLT,NFAI,NMAP,NSPN,NLOG
      INCLUDE "C.CONST.H"     ! COMMON/CONST/ CL9,CL ,PI,RAD,DEG,QE ,AMPROT, CM2M
      INCLUDE 'MXLD.H'
      INCLUDE "MAXTRA.H"
      INCLUDE "MAXCOO.H"
      LOGICAL AMQLU(5),PABSLU
      INCLUDE "C.FAISC.H"     ! COMMON/FAISC/ F(MXJ,MXT),AMQ(5,MXT),DP0(MXT),IMAX,IEX(MXT),
C     $     IREP(MXT),AMQLU,PABSLU
      CHARACTER(1) LET
      INCLUDE "C.FAISCT.H"     ! COMMON/FAISCT/ LET(MXT)
      INCLUDE "C.PTICUL.H"     ! COMMON/PTICUL/ AM,Q,G,TO
      INCLUDE "C.REBELO.H"   ! COMMON/REBELO/ NRBLT,IPASS,KWRT,NNDES,STDVM
      INCLUDE "C.RIGID.H"     ! COMMON/RIGID/ BORO,DPREF,HDPRF,DP,QBR,BRI
      INCLUDE "C.SPIN.H"     ! COMMON/SPIN/ KSPN,KSO,SI(4,MXT),SF(4,MXT)

      PARAMETER (LBLSIZ=20)
      CHARACTER(LBLSIZ) LBL(MLB)

      CHARACTER(80) FNAME
      LOGICAL BINARY, FITING

      CHARACTER(1) TX1
      PARAMETER (TX1='''')

      SAVE BINARY

      CALL FITSTA(5,
     >              FITING)
      IF(FITING) RETURN

      IF    (KPR .GE. 1) THEN
C------- store at ipass=1 & every ipass=multiple of KPR
        IF(IPASS .GT. 1) THEN
          IF(IPASS .LT. NRBLT) THEN
            IF(KPR*(IPASS/KPR) .NE. IPASS) RETURN
          ENDIF
        ENDIF
      ENDIF
 
      IF(BINARY) THEN

        DO I=1,IMAX
          P = BORO*CL9 *F(1,I) * AMQ(2,I)
          GA = SQRT(P*P/(AMQ(1,I)*AMQ(1,I)) + 1.D0)
          WRITE(NSPN) IEX(I),(SI(J,I),J=1,4),(SF(J,I),J=1,4),F(6,I)
     >    ,(GA-1.D0)*AMQ(1,I),I,IMAX,IPASS,NOEL,KLEY,LBL1,LBL2,LET(I)
        ENDDO

      ELSE

        DO I=1,IMAX
          P = BORO*CL9 *F(1,I) * AMQ(2,I)
          GA = SQRT(P*P/(AMQ(1,I)*AMQ(1,I)) + 1.D0)
          WRITE(NSPN,101) 
     >    IEX(I),(SI(J,I),J=1,4),(SF(J,I),J=1,4),F(6,I)
     >    ,(GA-1.D0)*AMQ(1,I),I,IMAX,IPASS,NOEL
     >    ,TX1,KLEY,TX1,TX1,LBL1,TX1,TX1,LBL2,TX1,TX1,LET(I),TX1

        ENDDO

        INCLUDE "FRMSPN.H"

      ENDIF

      CALL FLUSH2(NSPN,BINARY)

      RETURN

      ENTRY SPNPRW(FNAME,LBL,NLB)

C FM July 2015. 
C      IF(IPASS .EQ. 1) CALL OPEN2('SPNPRN',NSPN,FNAME)
      CALL OPEN2('SPNPRN',NSPN,FNAME)
      BINARY=FNAME(1:2).EQ.'B_' .OR. FNAME(1:2).EQ. 'b_'
      IF(NRES .GT. 0) THEN
        WRITE(NRES,FMT='(15X,
     >    ''Print of spin info will occur at element[s] labeled : '')') 
        WRITE(NRES,FMT='(20X,A)') (LBL(I),I=1,NLB)
      ENDIF

      RETURN
      END
