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
      SUBROUTINE CHXC(ND,KALC,KUASEX,BORO,DPREF,HDPRF,
     >                                 XL,DSREF,QSHROE,VSHROE)
      USE DYNHC
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
C     --------------------------------------------------
C     DEFINES THE FIELD:
C       KALC = 1: DEFINES A MAGNETIC FIELD IN THE MEDIAN
C                 PLANE + ASSUMES MID PLANE SYM
C       KALC = 2: READS A FIELD MAP
C       KALC = 3: DEFINES QUAD , SEXTU , ... , MULTPL...
C     --------------------------------------------------
      PARAMETER (MSR=8)
      CHARACTER(2) QSHROE(MSR)
      DIMENSION VSHROE(MSR)

      INCLUDE 'PARIZ.H'
      INCLUDE 'XYZHC.H'     ! COMMON// XH(MXX),YH(MXY),ZH(IZ),IXMA,JYMA,KZMA
      INCLUDE 'C.AIM.H'     ! COMMON/AIM/ BO,RO,FG,GF,XI,XF,EN,EB1,EB2,EG1,EG2
      INCLUDE 'C.CDF.H'     ! COMMON/CDF/ IES,LF,LST,NDAT,NRES,NPLT,NFAI,NMAP,NSPN,NLOG
      PARAMETER(MCOEF=6)
      INCLUDE 'C.CHAFUI.H'     ! COMMON/CHAFUI/ XE,XS,CE(MCOEF),CS(MCOEF),QCE(MCOEF),QCS(MCOEF)
      INCLUDE 'MAXTRA.H'
      INCLUDE 'C.CHAMBR.H' 
      INCLUDE 'C.CONST2.H'     ! COMMON/CONST2/ ZERO, UN
      INCLUDE 'MXLD.H'
      INCLUDE 'C.DON.H'     ! COMMON/DON/ A(MXL,MXD),IQ(MXL),IP(MXL),NB,NOEL
C      PARAMETER (LNTA=132) ; CHARACTER(LNTA) TA
C      PARAMETER (MXTA=45)
      INCLUDE 'C.DONT.H'     ! COMMON/DONT/ TA(MXL,MXTA)
C      PARAMETER (MDR=9)
      INCLUDE 'C.DROITE.H'     ! COMMON/DROITE/ CA(MDR),SA(MDR),CM(MDR),IDRT
      INCLUDE 'C.EFBS.H'     ! COMMON/EFBS/ AFB(2), BFB(2), CFB(2), IFB
      INCLUDE 'C.INTEG.H'     ! COMMON/INTEG/ PAS,DXI,XLIM,XCE,YCE,ALE,XCS,YCS,ALS,KP
      PARAMETER(MPOL=10)
      INCLUDE 'C.MULTPE.H'     ! COMMON/MULTPE/ EM(MPOL),QLE(MPOL),QLS(MPOL)
C      >,QE(MPOL,MCOEF),QS(MPOL,MCOEF),RTQ(MPOL) 
      INCLUDE 'C.MULTPL.H'     ! COMMON/MULTPL/ BM(MPOL),DLE(MPOL),DLS(MPOL),DE(MPOL,MCOEF),DS(MPOL,MCOEF),RTB(MPOL)
C     >,DE(MPOL,MCOEF),DS(MPOL,MCOEF),RTB(MPOL)
C      LOGICAL ZSYM
      INCLUDE 'C.TYPFLD.H'     ! COMMON/TYPFLD/ KFLD,MG,LC,ML,ZSYM
      INCLUDE 'C.ORDRES.H'     ! COMMON/ORDRES/ KORD,IRD,IDS,IDB,IDE,IDZ
      INCLUDE 'C.PTICUL.H'     ! COMMON/PTICUL/ AM,Q,G,TO
      INCLUDE 'C.REBELO.H'   ! COMMON/REBELO/ NRBLT,IPASS,KWRT,NNDES,STDVM
      INCLUDE 'MXFS.H'
      INCLUDE 'MXSCL.H'
      INCLUDE 'C.SCAL.H'     ! COMMON/SCAL/ SCL(MXF,MXS,MXSCL),TIM(MXF,MXS),NTIM(MXF),KSCL
      INCLUDE 'C.SPIN.H'     ! COMMON/SPIN/ KSPN,KSO,SI(4,MXT),SF(4,MXT)
      INCLUDE 'C.STEP.H'     ! COMMON/STEP/ TPAS(3), KPAS
      INCLUDE 'C.SYNRA.H'     ! COMMON/SYNRA/ KSYN
      INCLUDE 'C.VITES.H'     ! COMMON/VITES/ U(6,3),DQBR(6),DDT(6) 

      LOGICAL BINAR,BINARI,IDLUNI
      CHARACTER(LNTA) TITL
      CHARACTER(LNTA) NAMFIC
      CHARACTER(LNTA) NOMFIC(MXTA)
      DIMENSION CBM(MXX),HC1(MXX,MXY),RCS(MDR)
      INTEGER DEBSTR,FINSTR
 
      CHARACTER(10) LMNT(22)
      CHARACTER(10) KTOR(2)
 
      CHARACTER(6) ES(2)
      LOGICAL FLIP 
      SAVE IPREC
      INCLUDE 'FILPLT.H'

      PARAMETER (I0=0,I2=2,I3=3)
C      CHARACTER(120) FMTYP

      LOGICAL SUMAP
      SAVE NHDF
      LOGICAL STRCON, FITING
C      LOGICAL AGS, NEWFIC(MXTA)
      LOGICAL AGS, NEWFIC

      INCLUDE 'MXHD.H'

      SAVE YSHFT
 
      DIMENSION DBDX(3)

      PARAMETER (MXC = 4)
C Changed to allow positioning data after map name in MOD.MOD2=16.1-4
C      PARAMETER (MXAA2=24+MXC-1)
      PARAMETER (MXMAP=4)
      PARAMETER (MXAA2=MAX(24+MXC-1,20+10*MXMAP+9))
      DIMENSION AA(MXL,MXAA2)
      SAVE AA

      DATA AGS / .FALSE. /
      DATA NEWFIC / .TRUE. /
      DATA NHDF / 4 /
      DATA SUMAP /.FALSE./
      DATA (ES(I),I=1,2)/ 'ENTREE' , 'SORTIE' /
      DATA LMNT / 'DIPOLE', 'QUADRUPOLE', 'SEXTUPOLE', 'OCTUPOLE',
     > 'DECAPOLE' , 'DODECAPOLE', 
     > '14-POLE', '16-POLE', '18-POLE', '20-POLE', 
     > 'MULTIPOLE ', 8*' ', 'SOLENOID ', 'WIENFILTER', '2-ELC LENS' /
      DATA KTOR /  'CLAMPEES', 'PARALLELES' /
      DATA DTA1 / 0.D0 /
      DATA LUN / 0 / 
      DATA FLIP / .FALSE. / 
      DATA BMIN,BMAX,
     >      XBMI,YBMI,ZBMI,XBMA,YBMA,ZBMA, 
     >      BNORM,XNORM,YNORM,ZNORM / 9*0.D0, 3*1.D0 /

C- KALC = TYPE CALCUL : ANALYTIQUE + SYM PLAN MEDIAN (1) , ANALYTIQUE 3D (3)
C   &  CARTE (2)
  
C----- Some initializations and resets
      CALL KSMAP(
     >           IMAP)

      ZSYM=.TRUE.
      SUMAP = .FALSE.
      CALL CHAMK2(UN)
      CALL RAZ(DBDX,3)
      CALL CHAMK4(DBDX,3)
C      CALL RAZ (AA,MXL*MXAA2)
      CALL FITSTA(5,
     >              FITING)
      IF(.NOT. FITING) THEN 
        IF(KALC .EQ. 2 ) THEN
C--------- Field is defined by maps

C  LF = 1/2 : print field map in zgoubi.res/zgoubi.map
          LF =NINT(A(NOEL,1))
C  LST=1(2) : PRINT step by step coord. and field in zgoubi.res (zgoubi.plt)
          LST = LSTSET(NINT(A(NOEL,2)))

        ELSE
C          Field is defined by analytical models

          LST =LSTSET(NINT(A(NOEL,1)))
          LST2 = INT(10 * (A(NOEL,1) - NINT(A(NOEL,1))))
          CALL IMPPL3(LST2)
        ENDIF
      ELSE
        LF = 0
        LST = 0
        LST2 = 0
        CALL IMPPL3(LST2)
      ENDIF

      IF(LST.EQ.2 .OR. LST.GE.4) CALL OPEN2('CHXC',NPLT,FILPLT)
 
C     ... FACTEUR D'ECHELLE DES ChampS. UTILISE PAR 'SCALING'
      SCAL = SCAL0()
      IF(KSCL .EQ. 1) SCAL = SCAL0()*SCALER(IPASS,NOEL,
     >                                                 DTA1)

c      write(88,*) ' chxc scal ',kscl,noel,SCAL0(),SCALER(IPASS,NOEL,
c     >                                                 DTA1)
      
      XE = 0.D0
      XS = 0.D0
      XLIM = 0.D0
      IDRT = 0
      IFB = 0
      NND = 10
 
      XCE = 0.D0
      YCE = 0.D0
      ALE = 0.D0
      ZCE = 0.D0
      PHE = 0.D0
      TTA = 0.D0
      XCS = 0.D0
      YCS = 0.D0
      ALS = 0.D0
      ZCS = 0.D0
      PHS = 0.D0

C----- Default values of upper order of field derivative 
      IDE=4
      IDB=2

C----- Default values of upper order for mid-plane extrapolation
      IDZ=2

      GOTO (2001, 2002, 2003) KALC 
 
 2001 CONTINUE
C        ... KALC = 1: defines a magnetic field in the median plane
C            with median plane symmetry
 
        XL=A(NOEL,10)
        DSREF = XL
        RO  =A(NOEL,11)
        BO  =A(NOEL,12)*SCAL
        IF(BO .EQ. 0.D0) KFLD=0
        XI=0.D0
        XLIM=XL
        XF=XLIM
C FM, Dec 2011  
        XS = XLIM      

        IDZ=3
        IDB=3
        IRD=2
 
        IF    (KUASEX .EQ. 1 )   THEN
          IF(NRES.GT.0) THEN
            WRITE(NRES,108)
 108        FORMAT(/, 9X,' QUADRUPOLE  SPECIAL  POUR  LE  SPES2 ',/)
            WRITE(NRES,110) XL,RO,BO
 110        FORMAT(/,15X,'   Length  :',1P,G12.4,' cm'
     >            ,/,15X,' 1/2width  :',   G12.4,' cm'
     >            ,/,15X,'       BO  :',   G12.4,' kG',/)
          ENDIF
          BO=BO/RO
 
        ELSEIF(KUASEX .EQ. 3  .OR. KUASEX .EQ. 4) THEN
C         ****  QUADISEX & SEXQUAD. Champ DIPOLAIRE AVEC INDICES N, N' OU N''
 
          EN  =A(NOEL,20)
          EB1 =A(NOEL,21)
          EB2 =A(NOEL,22)
          EG1 =A(NOEL,23)
          EG2 =A(NOEL,24)

          IF(NRES.GT.0) THEN
            IF(KUASEX .EQ. 3) THEN
C-------------- QUADISEX
               WRITE(NRES,112)
 112           FORMAT(/,9X,'AIMANT  DE  Champ  CALCULE  B =',
     >         2X,'BO(1+N.Y/RO+B.Y2/RO2+G.Y3/RO3)')
            ELSE
C-------------- SEXQUAD
               WRITE(NRES,114)
 114           FORMAT(/,9X,'AIMANT  DE  Champ  CALCULE  B =',
     >         2X,'BO(N.Y/RO+B.Y2/RO2+G.Y3/RO3)')
            ENDIF
 
            WRITE(NRES,110) XLIM,RO,BO
            WRITE(NRES,116) EN,EB1,EB2,EG1,EG2
 116        FORMAT(55X,'N = ',F10.6,' POUR  Y  POSITIF '
     >          ,/,55X,'B = ',F10.6,' POUR  Y  NEGATIF'
     >          ,/,55X,'B = ',F10.6,' POUR  Y  NEGATIF'
     >          ,/,55X,'G = ',F11.8,' POUR  Y  POSITIF'
     >          ,/,55X,'G = ',F11.8,' POUR  Y  NEGATIF')
          ENDIF
 
          EN = EN / RO
          ROO = RO * RO
          EB1 = EB1 / ROO
          EB2 = EB2 / ROO
          ROOO = ROO * RO
          EG1 = EG1 / ROOO
          EG2 = EG2 / ROOO

        ELSEIF(KUASEX .EQ. 5 )   THEN
C--------- VENUS
          XL2 = XL / 2.D0
          XL2RO = XL2 / RO
          EB1 = 1.D0 / (1.D0 + XL2RO * XL2RO)
          XLMAG = 2.D0 * RO * ATAN(XL2RO) - XL2 * EB1
          EB1 = EB1 * BO

          XI=-XL / 2.D0
          XLIM=XL / 2.D0
          XF=XLIM
C FM, Dec 2011  
          XS = XLIM      
          IF(NRES.GT.0) THEN
            WRITE(NRES,118) 
 118        FORMAT(/, 9X,' Champ CONSTANT DANS UN RECTANGLE ',/)
            WRITE(NRES,124) XL,RO,BO
          ENDIF
          DSREF = ABS(XLMAG)

          IF( KP .EQ. 3 ) THEN
C             Stop if XCE .ne. 0. To be provisionned...
            IF(A(NOEL,ND+NND+1) .NE. 0.D0) 
     >      CALL ENDJOB('Pgm chxc. KPOS=3 does not support XCE.ne.',I0)
C            Calculate ALE as half BL/BRho. BL_arc???
            IF(A(NOEL,ND+NND+3) .EQ. 0.D0)   
     >        A(NOEL,ND+NND+3)= ASIN(.5D0*XLMAG*BO/BORO)
C Modified, FM, Dec 05 :
C            Calculate XCE, YCE for entrance change of referential    
            YSHFT = A(NOEL,ND+NND+2)
C            A(NOEL,ND+NND+1) = - YSHFT * SIN(A(NOEL,ND+NND+3))
C            A(NOEL,ND+NND+2) =   YSHFT * COS(A(NOEL,ND+NND+3))
            XCE = - YSHFT * SIN(A(NOEL,ND+NND+3))
            YCE =   YSHFT * COS(A(NOEL,ND+NND+3))
            GOTO 92

          ENDIF

        ELSEIF(KUASEX .EQ. 6 )   THEN
C--------- PS170
          IF(NRES.GT.0) THEN
            WRITE(NRES,122)
 122        FORMAT(/, 9X,' Champ CONSTANT DANS UN CERCLE ',/)
            WRITE(NRES,124) XLIM,RO,BO
 124        FORMAT(/,15X,'   Length  :',1P,G12.4,' cm'
     >             ,/,15X,'   radius  :',   G12.4,' cm'
     >             ,/,15X,'       BO  :',   G12.4,' kG',/)
          ENDIF
 
        ELSEIF(KUASEX .EQ. 7 )   THEN
C---------- Toroidal spectro for LNS
          EN  =A(NOEL,20)
          EB1 =A(NOEL,21)
          EB2 =A(NOEL,22)
          EG1 =A(NOEL,23)
          EG2 =A(NOEL,24)
          IF(NRES.GT.0) THEN
            WRITE(NRES,173)
 173        FORMAT(/, 9X,' Champ TOROIDAL DANS UN RECTANGLE ',/)
            WRITE(NRES,110) XLIM,RO,BO
            WRITE(NRES,174) KTOR(NINT(EN)),EB1,EB2,EG1,EG2
 174        FORMAT(/, 15X,' GAP  A  FACES  ',A
     >            ,/, 15X,' R1-4 = ',4F8.3,' CM',/)
          ENDIF
 
        ELSEIF(KUASEX .EQ. 8 )   THEN
C-------- BEND MAGNET

          CALL BENDI(SCAL,
     >                    XL,DEV)

          DSREF = ABS(DEV * (XL/(2.D0 * SIN(DEV/2.D0))))

          KP = NINT(A(NOEL,ND+NND))   
          IF( KP .EQ. 3 ) THEN
C            Stop if XCE .ne. 0. To be provisionned...

            IF(A(NOEL,ND+NND+1) .NE. 0.D0) 
     >      CALL ENDJOB('Pgm chxc. KPOS=3 does not support XCE.ne.',I0)

            IF(A(NOEL,ND+NND+3).EQ.0.D0) 
     >                      A(NOEL,ND+NND+3)=-DEV/2.D0
C Modified, FM, Dec 05 :
C             Calculate XCE, YCE for entrance change of referential    
            YSHFT = A(NOEL,ND+NND+2)
            XCE = - YSHFT * SIN(A(NOEL,ND+NND+3))
            YCE =   YSHFT * COS(A(NOEL,ND+NND+3))
C            A(NOEL,ND+NND+1) = - YSHFT * SIN(A(NOEL,ND+NND+3))
C            A(NOEL,ND+NND+2) =   YSHFT * COS(A(NOEL,ND+NND+3))
            GOTO 92

          ENDIF

        ELSEIF(KUASEX .EQ. 36 )   THEN
C--------- DIPOLEC

          CALL DIPCI(SCAL,
     >                    XL,DEV)
          DSREF = ABS(DEV * (XL/(2.D0 * SIN(DEV/2.D0))))

          KP = NINT(A(NOEL,ND+NND))
          IF( KP .EQ. 3 ) THEN
            IF(A(NOEL,ND+NND+1) .NE. 0.D0) 
     >      CALL ENDJOB('Pgm chxc. KPOS=3 does not support XCE.ne.',I0)
C             Calculate ALE as half deviation. 
            IF(A(NOEL,ND+NND+3).EQ.0.D0) 
     >                      A(NOEL,ND+NND+3)=-DEV/2.D0
C             Calculate XCE, YCE for entrance change of referential    
            YSHFT = A(NOEL,ND+NND+2)
C            A(NOEL,ND+NND+1) = - YSHFT * SIN(A(NOEL,ND+NND+3))
C            A(NOEL,ND+NND+2) =   YSHFT * COS(A(NOEL,ND+NND+3))
            XCE = - YSHFT * SIN(A(NOEL,ND+NND+3))
            YCE =   YSHFT * COS(A(NOEL,ND+NND+3))
            GOTO 92

          ENDIF

        ENDIF
C--------- KUASEX

      GOTO 91
 
C---------------------------------------------------------------
 2002 CONTINUE
C-------- KALC = 2: READS FIELD MAP

        RFR = 0.D0

        MOD = 0
        MOD2 = 0

        IF(KUASEX.EQ.2 .OR. KUASEX.EQ.7) THEN
C----- TOSCA. Read  2-D or 3-D field map (e.g., as obtained from TOSCA code), 
 
          IF(KUASEX .EQ. 2) THEN
C---------- 2 : TOSCA. Read a 2-D field map, assume Bx=By=0
            NDIM = 2

          ELSEIF(KUASEX.EQ.7) THEN
C-------- 7 : TOSCA. Read a 3-D field map, TOSCA data output format. 
            NDIM = 3

          ENDIF

          IRD = NINT(A(NOEL,ND-10))

          MOD = NINT(A(NOEL,23))
          MOD2 = NINT(10.D0*A(NOEL,23)) - 10*MOD

          CALL TOSCAC(SCAL,NDIM,
     >                          BMIN,BMAX,BNORM,XNORM,YNORM,ZNORM,
     >                          XBMI,YBMI,ZBMI,XBMA,YBMA,ZBMA,AA,NEWFIC)

C Steps back because this is settled after the endif...
          XBMA = XBMA/XNORM
          XBMI = XBMI/XNORM
          BMAX = BMAX/BNORM
          BMIN = BMIN/BNORM

          KP = NINT(A(NOEL,ND+NND))   
          IF( KP .EQ. 3 ) THEN
            CALL ENDJOB('Pgm chxc. KPOS=3 not supported with field map.'
     >      //' To be implemented.',-99)

            IF(A(NOEL,ND+NND+1) .NE. 0.D0) 
     >      CALL ENDJOB('Pgm chxc. KPOS=3 does not support XCE.ne.',I0)
C             Calculate XCE, YCE for entrance change of referential    
            YSHFT = A(NOEL,ND+NND+2)
            XCE = - YSHFT * SIN(A(NOEL,ND+NND+3))
            YCE =   YSHFT * COS(A(NOEL,ND+NND+3))

          ENDIF

        ELSEIF(KUASEX.EQ.9) THEN
C------------ 9 : MAP2D, MAP2D-E. READS A 2D FIELD MAP, 
C                  FORMAT OF MAP FILE = SAME AS TOSCA (PAVEL AKISHIN, JINR, 1992).
C------------ No 2nd-order 25-point interpolation available with MAP2D[_E]
          IF(IRD.EQ.25) IRD=2

          CALL MAP2D(SCAL,
     >                   BMIN,BMAX,BNORM,XNORM,YNORM,ZNORM,
     >                   XBMI,YBMI,ZBMI,XBMA,YBMA,ZBMA,NEWFIC)

C   Because it's done down after the endif...
          XBMA = XBMA/XNORM
          XBMI = XBMI/XNORM
          YBMA = YBMA/YNORM
          YBMI = YBMI/YNORM
          ZBMA = ZBMA/ZNORM
          ZBMI = ZBMI/ZNORM
          BMAX = BMAX/BNORM
          BMIN = BMIN/BNORM

        ELSEIF(KUASEX.EQ.34 .OR. KUASEX.EQ.35) THEN
C----------- EMMA 

          IF(KUASEX .EQ. 34) THEN
C--------- Reads a 2-D field map, assumes Bx=By=0
            NDIM = 2
          ELSEIF(KUASEX.EQ.35) THEN
C--------- Reads a 3-D field map, 
            NDIM = 3
          ENDIF
          CALL EMMAC(SCAL,NDIM, 
     >                         BMIN,BMAX,BNORM,XNORM,YNORM,ZNORM,
     >                         XBMI,YBMI,ZBMI,XBMA,YBMA,ZBMA,NEWFIC)

C Steps back because this is settled after the endif...
          XBMA = XBMA/XNORM
          XBMI = XBMI/XNORM
          BMAX = BMAX/BNORM
          BMIN = BMIN/BNORM

        ELSEIF(KUASEX .EQ. 8 ) THEN
C-------- BREVOL AND ELREVOL
C         Read a 1-D X-map of  Bx(R=0,X)-field,
C                          or  E(R=0,X)-field
C                                (x-cylindrical symmetry assumed)
          NDIM = 1
          CALL BREVOL(SCAL,
     >                    BMIN,BMAX,BNORM,XNORM,XBMI,XBMA,NEWFIC)

C   Because it's done down after the endif...
          XBMA = XBMA/XNORM
          XBMI = XBMI/XNORM
          BMAX = BMAX/BNORM
          BMIN = BMIN/BNORM


        ELSE

          NDIM=2
 
          BNORM = A(NOEL,10)*SCAL
          XNORM = A(NOEL,11)
          YNORM = A(NOEL,12)
          ZNORM = 1.D0

          TITL = TA(NOEL,1)
          IF    (STRCON(TITL,'HEADER',
     >                                 IS) ) THEN
            READ(TITL(IS+7:IS+7),FMT='(I1)') NHD
            ELSE
              NHD = NHDF
            ENDIF
            IF(NHD .GT. MXHD) CALL ENDJOB(
     >      'Pgm chxc. Field map headr has too many lines. Must be .le.'
     >      ,MXHD)

            IDEB = DEBSTR(TITL)
            FLIP = TITL(IDEB:IDEB+3).EQ.'FLIP'
            IXMA = NINT(A(NOEL,20))
            IF(IXMA.GT.MXX) 
     >        CALL ENDJOB('X-dim of map is too large,  max  is ',MXX)
            IF(NDIM .EQ. 1) THEN
              JYMA=1
            ELSE
              JYMA = NINT(A(NOEL,21))
              IF(JYMA.GT.MXY ) 
     >          CALL ENDJOB('Y-dim of map is too large,  max  is ',MXY)
              IF(NDIM .EQ. 3) THEN
                KZMA = NINT(A(NOEL,22))
                IF(KZMA.GT.IZ ) 
     >            CALL ENDJOB('Z-dim of map is too large,  max  is ',IZ)
              ENDIF
            ENDIF
 
            IF    (NDIM.LE.2 ) THEN
              I1 = 1
              KZMA = 1
              NFIC=0
 267          CONTINUE
                NFIC = NFIC+1
                NAMFIC = TA(NOEL,NFIC+1)
                IFN = FINSTR(NAMFIC)
                IDN = DEBSTR(NAMFIC)

                IF(NAMFIC(IDN:IDN).EQ.'+') THEN
C--------- Will sum (superimpose) 1D or 2D field maps if map file name is followed by 'SUM'
                  NAMFIC = NAMFIC(IDN+1:IFN)
                  SUMAP = .TRUE.
                ELSE
                  SUMAP = .FALSE.
                ENDIF
                NOMFIC(NFIC) = NAMFIC
                IF(SUMAP) GOTO 267

                JFIC = 1
                IF(IDLUNI(
     >                    LUN)) THEN
                  BINAR=BINARI(NOMFIC(JFIC), 
     >                                      IDUM)
                  IF(BINAR) THEN
                    OPEN(UNIT=LUN,FILE=NOMFIC(JFIC),FORM='UNFORMATTED'
     >              ,STATUS='OLD',ERR=96)
                  ELSE
                    OPEN(UNIT=LUN,FILE=NOMFIC(JFIC),
     >                                  STATUS='OLD',ERR=96)
                  ENDIF
                ELSE
                  GOTO 96 
                ENDIF
            
            ELSEIF(NDIM .EQ. 3 ) THEN
              MOD = NINT(A(NOEL,23))

              IF    (MOD .EQ. 0) THEN
C-------------- The 3-D map is symmetrised /  horizontal plane
                I1 = (KZMA/2) + 1
              ELSEIF(MOD .EQ. 1) THEN
                I1 = 1
C-------------- Map may be non-symm wrt. median plane, hence motion has no z-symm. 
                ZSYM=.FALSE.
              ELSEIF(MOD .EQ. 12) THEN
C------------- The all 3D map is contained in a single file
            ENDIF
            NFIC=0
            DO 129 I=I1,KZMA
              NFIC = NFIC+1
              NAMFIC = TA(NOEL,1+NFIC)
              NOMFIC(NFIC) = NAMFIC(DEBSTR(NAMFIC):FINSTR(NAMFIC))
 129        CONTINUE
          ENDIF
 
          IF(NRES.GT.0) THEN
            WRITE(NRES,209) ' Title in this field map problem : ', 
     >      TITL(DEBSTR(TITL):FINSTR(TITL))
 209        FORMAT(/,10X,2A)
            WRITE(NRES,*) ' A total of',NFIC,
     >                      ' field map(s) to be loaded :'
            WRITE(NRES,208) (NOMFIC(I)(DEBSTR(NOMFIC(I)):
     >    FINSTR(NOMFIC(I))),I=1,NFIC)
 208        FORMAT(10X,A)
          ENDIF

          BMIN =  1.D10
          BMAX = -1.D10

          IDZ=2
          IRD = NINT(A(NOEL,40))
          IF(IRD .EQ. 4) THEN
            IDZ=4
            IDB=4
          ENDIF

          IF(KUASEX .EQ. 1 ) THEN
C---------- CARTEMES
C----------- CARTE MESUREE DU SPES2 (CEA-SACLAY)

            CALL KSMAP5(
     >                  IMAP)

            IF(BINAR) THEN
              READ(LUN) (YH(J),J=1,JYMA)
            ELSE
              READ(LUN,400) (YH(J),J=1,JYMA)
            ENDIF
            DO 212 I=1,IXMA
              IF(BINAR) THEN
                READ(LUN) XH(I),(CBM(J),J=1,JYMA)
              ELSE
                READ(LUN,401) XH(I),(CBM(J),J=1,JYMA)
              ENDIF
              DO  212  J = 1,JYMA
                IF(CBM(J) .GT. BMAX) THEN
                  BMAX = CBM(J)
                  XBMA = XH(I)
                  YBMA = YH(J)
                ELSEIF(CBM(J) .LT. BMIN) THEN
                  BMIN = CBM(J)
                  XBMI = XH(I)
                  YBMI = YH(J)
                ENDIF
                HC(ID,I,J,1,IMAP) = CBM(J) * BNORM
 212        CONTINUE
 
          ELSEIF(KUASEX .EQ. 3 ) THEN
C------------ CARTE MESUREE DU SPES3 (CEA-SACLAY)
 
            CALL KSMAP5(
     >                  IMAP)

            XX0=0D0
            YY0=0D0
 
            XX=-2.D0+XX0
            do 510 i=1,IXMA
              XX=XX+2.D0
 510          XH(I)=XX
 
            YY=-2.D0+YY0
            DO 511 J=1,JYMA
              YY=YY+2.D0
511           YH(J)=YY
 
 
C      skip blocks 1 to 9
 
            do 7000 i = 1,144
              read(lun,*)
7000        continue
 
C      read in magnetic field
 
             do 8000 i = 1,MXY
               read(LUN,*)
               kmax = 140
               if (i.ge.101) kmax = 270
               do 8600 k = 0,kmax,10
               read(LUN,8103,ERR=8801,END=8802) (HC1(k+j,i),j=1,10)
8103           format(2x,10f7.0)
8600         continue
8000         continue
             GOTO 8901
8801         IF(NRES .GT. 0) WRITE(NRES,*) ' ERROR  reading  field...'
             IF(NRES .GT. 0) WRITE(NRES,8103) (HC1(k+j,i),j=1,10)
             GOTO 8901
8802         IF(NRES .GT. 0) WRITE(NRES,*) 
     >                    ' OK !  FIN  DE  FICHIER  RENCONTREE...'
 
C     inversion of x-axis and from G to kG
 
8901         CONTINUE
             do 8800 i = 1,MXY
              do 8800 j = 1,280
               HH = hc1(281-j,i)/1.D3
               IF    (HH .GT. BMAX) THEN
                 BMAX = HH
                 XBMA = XH(281-J)
                 YBMA = YH(I)
               ELSEIF(HH .LT. BMIN) THEN
                 BMIN = HH
                 XBMI = XH(281-J)
                 YBMI = YH(I)
               ENDIF
               HC(ID,J,I,1,IMAP) = HH
8800         CONTINUE
C    +++++++++++++++++++++++++++
 
C     set magnetic field before target position to 0.
 
             do 8820 i = 1,MXY
              do 8820 j = 1,18
8820            hc(id,j,i,1,IMAP) = 0D0
             IRCHA = 1
 
             DO 232 I=1,IXMA
               DO  232  J = 1,JYMA
                 HC(ID,I,J,1,IMAP) = HC(ID,I,J,1,IMAP) * BNORM
 232         CONTINUE
 
          ELSEIF(KUASEX .EQ. 4 ) THEN
C----------- CARTE CARTESIENNE 2-D DE CHALUT
 
            CALL KSMAP5(
     >                  IMAP)

            DO 63 J=1,55
              READ(LUN,*)
 63         CONTINUE
 
            DO  64  J = 1,JYMA
              YH(J) = 2.D0*(J-1.D0)-22D0
 64         CONTINUE
 
            DO 242 I=1,IXMA
              READ(LUN,143) XH(I)
 143          FORMAT(F10.3)
              IF(BINAR) THEN
                READ(LUN) (CBM(J),J=1,JYMA)
              ELSE
                READ(LUN,142) (CBM(J),J=1,JYMA)
 142            FORMAT(7F10.3)
              ENDIF
              DO  242  J = 1,JYMA
                IF    (CBM(J) .GT. BMAX) THEN
                  BMAX = CBM(J)
                  XBMA = XH(I)
                  YBMA = YH(J)
                ELSEIF(CBM(J) .LT. BMIN) THEN
                  BMIN = CBM(J)
                  XBMI = XH(I)
                  YBMI = YH(J)
                ENDIF
                HC(ID,I,J,1,IMAP) = CBM(J) * BNORM
 242         CONTINUE
 
          ELSEIF(KUASEX .EQ. 5 ) THEN
C------------ CARTE CARTESIENNE 2-D POISSON
 
            CALL KSMAP5(
     >                  IMAP)

            CALL RDPOIS(LUN,IXMA,JYMA,XH,YH,CBM)
            DO 252 J=1,JYMA
              DO  252  I = 1,IXMA
                IF    (CBM(I) .GT. BMAX) THEN
                  BMAX = CBM(I)
                  XBMA = XH(I)
                  YBMA = YH(J)
                ELSEIF(CBM(I) .LT. BMIN) THEN
                  BMIN = CBM(I)
                  XBMI = XH(I)
                  YBMI = YH(J)
                ENDIF
                HC(ID,I,J,1,IMAP) = CBM(I) * BNORM
 252        CONTINUE
  
          ELSEIF(KUASEX .EQ. 6 ) THEN
C----------- CARTE MESUREE SPECTRO KAON GSI (DANFISICS)
 
            CALL KSMAP5(
     >                  IMAP)

            YH(1)=-91.D0
            DO 624 J=2,JYMA
              YH(J)=YH(J-1)+3.D0
 624        CONTINUE
            XH(1)=-57.D0
            DO 623 I=2,IXMA
              XH(I)=XH(I-1)+3.D0
 623        CONTINUE
 
            DO 622 I=1,IXMA
              IF(BINAR) THEN
                READ(LUN,ERR=97) (CBM(J),J=1,JYMA)
              ELSE
                READ(LUN,602,ERR=97) (CBM(J),J=1,JYMA)
 602            FORMAT(6E13.5,/,E12.5,3E13.5)
              ENDIF
              DO 625 J=1,JYMA
                IF(CBM(J) .GT. BMAX) THEN
                  BMAX = CBM(J)
                  XBMA = XH(I)
                  YBMA = YH(J)
                ELSEIF(CBM(J) .LT. BMIN) THEN
                  BMIN = CBM(J)
                  XBMI = XH(I)
                  YBMI = YH(J)
                ENDIF
                HC(ID,I,J,1,IMAP) = CBM(J) * BNORM
 625          CONTINUE
 622        CONTINUE
 
          ENDIF
        ENDIF
C        ... ENDIF KUASEX

        CLOSE(UNIT=LUN)
C Check that : close does not seem to idle lun => makes problem with FIT !!   

        XBMA = XBMA*XNORM
        XBMI = XBMI*XNORM
        YBMA = YBMA*YNORM
        YBMI = YBMI*YNORM
        ZBMA = ZBMA*ZNORM
        ZBMI = ZBMI*ZNORM
        BMAX = BMAX*BNORM
        BMIN = BMIN*BNORM
        XI =XH(1)
        XF =XH(IXMA)
        XL = XF - XI
        DSREF = XL

        CALL INIDRT(TITL,ND,XI,
     >                         RCS)

        IF(NRES.GT.0) THEN
 
          IF(FLIP) THEN
            IF(KUASEX .EQ. 2) THEN
              WRITE(NRES,FMT='(/,5X,'' Field map has been flipped '')')
            ELSE
              WRITE(NRES,FMT='(/,5X,'' FLIP not yet implemented...'')')
            ENDIF
          ENDIF

          IF(MOD2 .GE. 1 ) THEN
            IF    (MOD2 .EQ. 1 ) THEN
              WRITE(NRES,FMT='(5X,''Field map scaled by''
     >      ,'' factor  a(1) = '',1P, E14.6)') AA(NOEL,24)
            ELSEIF(MOD2 .LE. MXC ) THEN
              WRITE(NRES,FMT='(5X,''Field from '',I2
     >        ,'' map(s) is combined (summed up) with linear ''
     >        ,''combination coefficient(s) a(i=1-4), respectively) : ''
     >        ,/,10X,1P, 4E14.6
     >        )') MOD2, (AA(NOEL,I),I = 24, 23+MOD2)
            ELSE
              CALL ENDJOB('Pgm chxc. No such possibility, MOD2 = ',MOD2)
            ENDIF
          ELSE
C            CALL ENDJOB('Pgm chxc. No such possibility, MOD2 == ',MOD2)
          ENDIF

C FM Apr 2015, for map-2d
C          WRITE(NRES,203) BMIN/BNORM,BMAX/BNORM,
C     >     XBMI,YBMI,ZBMI,XBMA,YBMA,ZBMA, 
C     >     BNORM,XNORM,YNORM,ZNORM,
C     >     BMIN*bnorm,BMAX*bnorm,
C     >     XBMI*XNORM,YBMI*YNORM,ZBMI*ZNORM,
C     >     XBMA*XNORM,YBMA*YNORM,ZBMA*ZNORM, 
          WRITE(NRES,203) BMIN/BNORM,BMAX/BNORM,
     >    XBMI/XNORM,YBMI/YNORM,ZBMI/ZNORM,
     >    XBMA/XNORM,YBMA/YNORM,ZBMA/ZNORM, 
     >    BNORM,XNORM,YNORM,ZNORM,
     >    BMIN,BMAX,XBMI,YBMI,ZBMI, 
     >    XBMA,YBMA,ZBMA, 
     >    XL, XI, XF, 
     >    IXMA,JYMA, XH(2)-XH(1), YH(2)-YH(1)
  203     FORMAT(
     >    /,5X,'Min/max fields found in map (series) read   : ', 
     >                              1P,E14.6,T68,'/ ',E14.6
     >    , /,5X,'  @  X,  Y, Z : ', 3(G10.3,1X),T68
     >                                     ,'/ ',3(G10.3,1X)
     >    ,/,5X,'Given normalisation coeffs on field, x, y, z'
     >    ,' : ', 4(E14.6,1X)
     >    , /,5X,'this yields min/max normalised fields (kG) :', 
     >                                                 2(E14.6,20X)
     >    , /,5X,'  @  X (cm),  Y (cm), Z (cm) : ', 3(G10.3,1X),T68
     >                                     ,'/ ',3(G10.3,1X)
     >    ,//,5X,'Length of element,  XL =',E14.6,' cm '
     >    , /,T48,'from  XI = ',E14.6,' cm '
     >    , /,T48,'to    XF = ',E14.6,' cm '
     >    ,//,5X,'Nbr of nodes in X =',I4,';  nbr of nodes in Y =',I5
     >    , /,5X,'X-size of mesh =',E14.6,' cm ; Y-size =',E14.6,' cm')

          IF(NDIM .EQ. 3) THEN
C            I2=2 introduced to avoid compiler complainig when IZ=1...

            IF    (MOD .EQ. 0) THEN
              KNOD = 2*KZMA-1
            ELSEIF(MOD .EQ. 1) THEN
              KNOD = KZMA
            ELSEIF(MOD .EQ. 12) THEN
              IF   (MOD2 .EQ. 1) THEN
                KNOD = KZMA
              ELSEIF(MOD2 .EQ. 2) THEN
                KNOD = 2*KZMA-1
              ELSE
                KNOD = 2*KZMA-1
              ENDIF
            ELSEIF(MOD .EQ. 15) THEN
              KNOD = KZMA
            ELSEIF(MOD .EQ. 16) THEN
              KNOD = KZMA
            ELSE
              CALL ENDJOB('Pgm chxc. No such option MOD = ',MOD)
            ENDIF
            WRITE(NRES,FMT='(5X,
     >      ''nber of mesh nodes in Z ='',I5,'' ; Step in Z ='',E14.6,
     >                                 '' cm'')') KNOD,ZH(I2)-ZH(1)
          ENDIF
          IF(IDRT .NE. 0) THEN
            IF    (IDRT .EQ. -1) THEN
              WRITE(NRES,403)
     >        ES(1),CA(1)*RCS(1),SA(1)*RCS(1),CM(1)*RCS(1)
 403          FORMAT(5X,' DROITE  DE  COUPURE  ',A6,'  D''EQUATION'
     >        ,5X,'(',F11.3,')*X + (',F11.3,')*Y + (',F11.3,') =0')
            ELSEIF(IDRT .EQ. 1) THEN
              WRITE(NRES,403)
     >        ES(2),CA(2)*RCS(2) ,SA(2)*RCS(2) ,CM(2)*RCS(2)
            ELSEIF(IDRT .GE. 2) THEN
              WRITE(NRES,403) ( ES(I),CA(I)*RCS(I)
     >        ,SA(I)*RCS(I) ,CM(I)*RCS(I) , I=1,IDRT)
            ENDIF
          ENDIF
 
          IF    (NDIM .EQ. 1) THEN
            WRITE(NRES,111) IRD
          ELSEIF(NDIM .EQ. 2) THEN
            WRITE(NRES,111) IRD
 111        FORMAT(/,20X,' OPTION  DE  CALCUL  :',I2)
            IF(IRD .EQ. 2) THEN
              WRITE(NRES,113)
 113          FORMAT(20X,' LISSAGE  A   9  POINTS ')
            ELSE
C             .... IRD=4 OU 25
              WRITE(NRES,115)
 115          FORMAT(20X,' LISSAGE  A  25  POINTS ')
            ENDIF
          ELSEIF(NDIM .EQ. 3) THEN
            WRITE(NRES,119) IRD
 119        FORMAT(/,20X,' OPTION  DE  CALCUL  :  GRILLE  3-D',2X,
     >      'A  3*3*3  POINTS , INTERPOLATION  A  L''ORDRE ',I2)
          ENDIF
 
          IF(LF .NE. 0 .AND. IPASS .EQ. 1) CALL FMAPW(ZERO,RFR,1)
 
        ENDIF
C        ... endif NRES>0
 
        CALL MAPLI1(BMAX-BMIN)

      IF(KP .EQ. 3) GOTO 92
      GOTO 91
 
C---------------------------------------------------------------
 2003 CONTINUE
C----- KALC = 3: DIP,QUAD, ... DODECA, MULTPL, SOLENOID, WIENFILTER, COILS
C        EL2TUB, UNIPOT

      IF(KUASEX .LE. MPOL+1 )   THEN
C-------- QUAD, ... DODECA, MULTPL
C        B (KFLD=MG) or E (KFLD=LC) or EB (KFLD=ML)
 
        IRD = KORD
        IF(IRD .EQ. 4) IDB=4

C Modif, FM, Dec. 05
C        IF(KUASEX .EQ. MPOL+1) NND = 1
        IF(KUASEX .EQ. MPOL+1) NND = 3

        IF(KFLD .EQ. MG) THEN
C---------- Magnetic
          CALL MULTPO(KUASEX,LMNT,MG,SCAL,
     >DEV,RTB,XL,BM,DLE,DLS,DE,DS,XE,XS, CE ,CS ,BORO,DPREF,HDPRF,*95)
               DSREF = XL
        ELSEIF(KFLD .EQ. LC) THEN
C---------- Electric
          CALL MULTPO(KUASEX,LMNT,LC,SCAL,
     >DEV,RTQ,XL,EM ,QLE,QLS,QE,QS,XE,XS,QCE,QCS,BORO,DPREF,HDPRF,*95)
        ELSEIF(KFLD .EQ. ML) THEN
C---------- Electric & Magnetic
          CALL MULTPO(KUASEX,LMNT,LC,SCAL,
     >DEV,RTQ,XL,EM ,QLE,QLS,QE,QS,XE,XS,QCE,QCS,BORO,DPREF,HDPRF,*95)
          CALL MULTPO(KUASEX,LMNT,MG,SCAL,
     >DEV,RTB,XL,BM,DLE,DLS,DE,DS,XE,XS, CE ,CS ,BORO,DPREF,HDPRF,*95)
        ENDIF
        KP = NINT(A(NOEL,ND+NND))
        IF( KP .EQ. 3 ) THEN
C             Calculate ALE as half deviation. 
          IF(A(NOEL,ND+NND+3).EQ.0.D0) 
     >                           A(NOEL,ND+NND+3)=-DEV/2.D0

          IF(A(NOEL,ND+NND+1) .NE. 0.D0) CALL ENDJOB('Pgm chxc. '//
     >    'X-shift has to be installed. ',7)
C Modified, FM, Feb. 05 :
C           Calculate XCE, YCE for entrance change of referential    
          YSHFT = A(NOEL,ND+NND+2)
C           A(NOEL,ND+NND+1) = - YSHFT * SIN(A(NOEL,ND+NND+3))
C           A(NOEL,ND+NND+2) =   YSHFT * COS(A(NOEL,ND+NND+3))
c Test, Dec. 06 :
          XCE = - YSHFT * SIN(A(NOEL,ND+NND+3))
          YCE =   YSHFT * COS(A(NOEL,ND+NND+3))

          GOTO 92

        ELSEIF( KP .EQ. 4 ) THEN  

          TTA = -DEV/2.D0 
          DTTA = A(NOEL,ND+NND+3)
C          DTTA2 = DTTA/2.D0
          IF(KUASEX.EQ.37) THEN
            CALL AGSK13(NINT(A(NOEL,1)),NOEL,
     >                                    YSHFT1)  ! Case of AGS Main Magnet
          ELSE
            YSHFT1 = 0.D0
          ENDIF

          YSHFT = A(NOEL,ND+NND+2) + YSHFT1
CCC FM. Sept 2017. Had to change, in order to match CHANGREF w same xce, yce, ale
cccc          XCE = - YSHFT * SIN(TTA) - XL* SIN(DTTA2) * SIN(TTA+DTTA2)
cccc          YCE =   YSHFT * COS(TTA) + XL* SIN(DTTA2) * COS(TTA+DTTA2)
          XCE = - YSHFT * SIN(TTA) + XL/2.D0 * (1.D0 -COS(DTTA))
          YCE =   YSHFT * COS(TTA) - XL/2.D0 * SIN(DTTA)

          IF(A(NOEL,ND+NND+1) .NE. 0.D0) CALL ENDJOB('Pgm chxc. '//
     >    'X-shift has to be installed. ',7)

C Z-shift
          ZSHFT = A(NOEL,ND+NND+4)
C Y-rotation PHE
          PHE = A(NOEL,ND+NND+5)
          XCEB =  - 0.5D0*XL * (1.D0 - COS(PHE))
          ZCE = 0.5D0*XL * SIN(PHE) 
          IF(PHE .NE. 0.D0) CALL ENDJOB('Pgm chxc. '//
     >    'Y-rotation has to be benchmarked. ',7)

          CALL QUASE2(YSHFT,DTTA,ZCE,PHE)    

          ALE  = A(NOEL,ND+NND+3) + TTA

          QSHROE(1) = 'XS'
          VSHROE(1) = XCE
          QSHROE(2) = 'YS'
          VSHROE(2) = YCE
          QSHROE(3) = 'ZR'
          VSHROE(3) = ALE
C Z-shift
          QSHROE(4) = 'ZS'
          VSHROE(4) = ZSHFT
C Y-rotation 
          QSHROE(5) = 'XS'
          VSHROE(5) = XCEB
          QSHROE(6) = 'ZS'
          VSHROE(6) = ZCE
          QSHROE(7) = 'YR'
          VSHROE(7) = PHE
          VSHROE(MSR) = 7

          GOTO 93

        ENDIF

      ELSEIF(KUASEX .EQ. 20 )   THEN
C--------- SOLENOID
        CALL SOLENO(KUASEX,LMNT,SCAL,  
     >                               XL)
C           Motion in this lmnt has no z-symm. 
        ZSYM=.FALSE.
 
      ELSEIF(KUASEX .EQ. 21)   THEN
C--------- WIENFILT
        IDZ=2
        CALL WIENFI(SCAL,  XL)
C         Motion in this lmnt has no z-symm. 
        ZSYM=.FALSE.
 
      ELSEIF(KUASEX .EQ. 22)   THEN
C--------- EL2TUB.
        CALL EL2TUB(SCAL,  XL)
C         Motion in this lmnt has no z-symm. 
        ZSYM=.FALSE.
 
      ELSEIF(KUASEX .EQ. 23)   THEN
C--------- UNIPOT
        CALL UNIPOT(SCAL,  XL)
C         Motion in this lmnt has no z-symm. 
        ZSYM=.FALSE.

      ELSEIF(KUASEX .EQ. 25)   THEN
C------- ELMIR
C------- field derivatives provided to second order (by SBR ELMIRF)
        IDE=2
        CALL ELMIRI(SCAL,  
     >                   XL,DEV)
        ZSYM=.FALSE.

        KP = NINT(A(NOEL,ND+NND))
        IF( KP .EQ. 3 ) THEN
C          Stop if XCE .ne. 0. To be provisionned...
          IF(A(NOEL,ND+NND+1) .NE. 0.D0) 
     >    CALL ENDJOB('Pgm chxc.  KPOS=3 does not support XCE.ne.',I0)
C           Calculate ALE as half deviation. 
          IF(A(NOEL,ND+NND+3).EQ.0.D0) 
     >    CALL ENDJOB('Pgm chxc.  ELMIR :  ALE  cannot be ',I0)
C Modified, FM, Dec 05 :
C          Calculate XCE, YCE for entrance change of referential    
          YSHFT = A(NOEL,ND+NND+2)
C          A(NOEL,ND+NND+1) = - YSHFT * SIN(A(NOEL,ND+NND+3))
C          A(NOEL,ND+NND+2) =   YSHFT * COS(A(NOEL,ND+NND+3))
          XCE = - YSHFT * SIN(A(NOEL,ND+NND+3))
          YCE =   YSHFT * COS(A(NOEL,ND+NND+3))
          GOTO 92
        ENDIF
C           Motion in this lmnt has no z-symm. 

      ELSEIF(KUASEX .EQ. 28 ) THEN
C------- HELIX
        CALL HELIX(SCAL,
     >                  XL)
      ELSEIF(KUASEX .EQ. 29 )   THEN
C------- COILS
        CALL COILS(SCAL,  
     >                  XL)
C         Motion in this lmnt has no z-symm. 
        ZSYM=.FALSE.
 
      ELSEIF(KUASEX .EQ. 30)   THEN
C------- UNDULATOR
        RO=1.D10
        CALL UNDULI(SCAL,
     >                   XL)

      ELSEIF(KUASEX .EQ. 37 )   THEN
C------- AGSMM. AGS main magnet

        IRD = KORD
        IF(IRD .EQ. 4) IDB=4

        NND = 10
        NPOL = I3

        CALL AGSMM(LMNT,MG,MPOL,NPOL,SCAL,
     >  DEV,RTB,XL,BM,DLE,DLS,DE,DS,XE,XS,CE,CS,BORO,DPREF,HDPRF)
          
        DSREF = XL
        KP = NINT(A(NOEL,ND+NND))

        IF( KP .EQ. 3 ) THEN
          IF(A(NOEL,ND+NND+3).EQ.0.D0) A(NOEL,ND+NND+3)=-DEV/2.D0
          CALL AGSK11(
     >                YSHFT)
c Test, Dec. 06 :
          XCE = - YSHFT * SIN(A(NOEL,ND+NND+3))
          YCE =   YSHFT * COS(A(NOEL,ND+NND+3))

          GOTO 92

        ELSEIF( KP .EQ. 4 ) THEN

          TTA = +DEV/2.D0 
          DTTA = A(NOEL,ND+NND+3)
          DTTA2 = DTTA/2.D0
          CALL AGSK11(
     >                YSHFT1)

          YSHFT = A(NOEL,ND+NND+2) + YSHFT1
          XCE = - YSHFT * SIN(TTA) - xl* sin(dtta2) * sin(tta+dtta2)
          YCE =   YSHFT * COS(TTA) + xl* sin(dtta2) * cos(tta+dtta2)
C Z-shift
          ZSHFT = A(NOEL,ND+NND+4)
C Y-rotation
          PHE = A(NOEL,ND+NND+5)
          XCEB =  - 0.5D0*XL * (1.D0 - COS(PHE))
          ZCE = 0.5D0*XL * SIN(PHE) 

          CALL QUASE2(YSHFT,DTTA,ZCE,PHE)    

          ALE  = A(NOEL,ND+NND+3) + TTA

          QSHROE(1) = 'XS'
          VSHROE(1) = XCE
          QSHROE(2) = 'YS'
          VSHROE(2) = YCE
          QSHROE(3) = 'ZR'
          VSHROE(3) = ALE
C Z-shift
          QSHROE(4) = 'ZS'
          VSHROE(4) = ZSHFT
C Y-rotation 
          QSHROE(5) = 'XS'
          VSHROE(5) = XCEB
          QSHROE(6) = 'ZS'
          VSHROE(6) = ZCE
          QSHROE(7) = 'YR'
          VSHROE(7) = PHE
          VSHROE(MSR) = 7
C            Vshroe(MSR) = 6

          GOTO 93

        ENDIF

      ELSEIF(KUASEX .EQ. 38)   THEN
C-------- AGSQUAD
 
        IRD = KORD
        IF(IRD .EQ. 4) IDB=4

        CALL AGSQUA(LMNT,MPOL,SCAL,
     >  DEV,RTB,XL,BM,DLE,DLS,DE,DS,XE,XS,CE,CS,BORO,DPREF,HDPRF)

        DSREF = XL

        KP = NINT(A(NOEL,ND+NND))

      ENDIF
C------------------- ENDIF KUASEX

      DSREF = XL
C----- End 2003
C----- END KALC=1-3


C-------------------------------------------------------------------
 91   CONTINUE
      XCE  = A(NOEL,ND+NND+1)
      YCE  = A(NOEL,ND+NND+2)
 92   CONTINUE
      ALE  = A(NOEL,ND+NND+3)
 93   CONTINUE

      PAS = A(NOEL,ND)
      KP = NINT(A(NOEL,ND+NND))

      IF(KSCL .EQ. 1
C------ Cavity
     >  .OR. KSYN.EQ.1) THEN
C------------SR Loss

        IF(NRES .GT. 0) THEN
          IF(KUASEX .EQ. 37 )   THEN
            WRITE(NRES,FMT='(
     >      /,10X,''AGS dipole. K1 and K2 computed from '',
     >      ''momentum-dependent law''
     >      )')
          ENDIF
          WRITE(NRES,199) SCAL
 199      FORMAT(/,20X,'Field has been * by scaling factor ',1P,G16.8)
        ENDIF

      ENDIF

      IF(KFLD.GE.LC) THEN
        IF(Q*AM .EQ. 0.D0) 
     >  CALL ENDJOB('Give  mass  and  charge - keyword PARTICUL',-99)
      ENDIF
 
C----- Some more actions on Magnetic Multipoles, BEND, etc.  :
C          - automatic positioning in SBR TRANSF,
C          - warning on z-foc. if sharp edge dipole field

      IF(NRES.GT.0) THEN
        IF( KP .EQ. 3)  THEN
          WRITE(NRES,FMT='(/,5X,''KPOS = '',I2,'' :'',
     >    ''  automatic positioning of element, '',/,
     >    8X,''XCE, YCE, ALE ='',
     >          1P,3G18.10,'' cm/cm/rad'' : )') KP,XCE,YCE,ALE
        ELSEIF( KP .EQ. 4)  THEN
          WRITE(NRES,FMT='(/,5X,''KPOS = '',I2,'' :'',
     >    ''  automatic positioning of element, '',/,
     >    8X,''XCE,YCE,Z-rot,ZCE,Y-rot =''
     >    ,1P,5G16.8,'' cm/cm/rad/cm/rad'' : )') KP,XCE,YCE,ALE,ZCE,PHE
        ELSEIF( KP .EQ. 5)  THEN
          WRITE(NRES,FMT='(/,5X,''KPOS = '',I2,'' :'',
     >    ''  Positioning of element, '',/,
     >    8X,''X-, Y-, Z-shift, X-, Y-, Z-rotation : ''
     >    ,1P,6G14.6,'' 3*cm/3*rad '' : )') KP,XCE,YCE,ZCE,XRO,YRO,ZRO
        ENDIF
      ENDIF

      IF( KPAS .GT. 0 ) THEN
C------- Coded step size of form  #stp_1|stp_2|stp_3, stp_i= arbitrary integer
C                                    entr body exit
C      (max stp_i is MXSTEP as assigned in SBR INTEGR), 
C                      step size = length/stp_i
C------- KPAS=2 -> Variable step

C Modif, FM, Dec. 05
C        STP1 = A(NOEL,ND-2)
C        STP2 = A(NOEL,ND-1)
C        STP3 = A(NOEL,ND)
        STP1 = A(NOEL,ND)
        STP2 = A(NOEL,ND+1)
        STP3 = A(NOEL,ND+2)
        TPAS(1) = 2.D0 * XE / STP1
        TPAS(2) = ( XL - XE - ( XLIM - XS ) ) / STP2
        TPAS(3) = 2.D0 * ( XLIM - XS ) / STP3

        IF(NRES.GT.0) WRITE(NRES,101) (TPAS(I),I=1,3), 
     >                               INT(STP1),INT(STP2),INT(STP3)
 101      FORMAT(/,20X,
     >    'Integration steps inside entrance|body|exit region : ',
     >    /,1P,T36,3G11.3,' (cm)',
     >       /,T36,I3,T47,I6,T58,I3,/)

        IF(KPAS.EQ.2) THEN
          IF(NRES.GT.0) 
     >       WRITE(NRES,FMT='(/,25X,'' ++ Variable step ++'',/,
     >            25X,'' PRECISION ='',1P,G12.4,/)') 10.D0**(-IPREC)
        ENDIF
        
      ELSE

        IF(NRES.GT.0) WRITE(NRES,102) PAS
 102    FORMAT(/,20X,'Integration step :',1P,G12.4,' cm',/)

      ENDIF

      GOTO 99

 97   NRES = ABS(NRES)
      WRITE(NRES,200) 'Pgm chxc. ERROR DURING READ IN ',NOMFIC(NFIC)
      WRITE(NRES,*) '                 AT NODE IX =',I,',  IY =',J
      CALL ENDJOB('Execution stopped : error during READ  ',-99)
 96   NRES = ABS(NRES)
      WRITE(NRES,200) 'Pgm chxc. ERROR  OPEN  FILE ',NOMFIC(NFIC)
      CALL ENDJOB('Execution stopped : error at OPEN  file  ',-99)
 95   NRES = ABS(NRES)
      WRITE(NRES,FMT=
     > '(//,''Pgm chxc.  Error  in  data  list'')')
      WRITE(6,FMT=
     > '(//,''  Error  in  data  list'',
     >        /,''    * See zgoubi.res'',//)')
      CALL ENDJOB('Execution stopped, data list error ',-99)

 99   CONTINUE

      RETURN

      ENTRY CHXC1R(
     >             KPASO)
      KPASO = KPAS
      RETURN

      ENTRY CHXC1W(KPASI,IPRECI)
      KPAS = KPASI
      IPREC = IPRECI
      IF(KPAS .EQ. 2) CALL DEPLAW(.TRUE.,IPREC)
      RETURN

  200 FORMAT(2A)
 400   FORMAT(10E8.1)
 401   FORMAT(10E8.1)
      END
