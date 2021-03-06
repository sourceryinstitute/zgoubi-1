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
C  Francois Meot <fmeot@bnl.gov>
C  Brookhaven National Laboratory
C  C-AD, Bldg 911
C  Upton, NY, 11973, USA
C  -------
      SUBROUTINE SCALIN
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
 
      INCLUDE "C.CDF.H"     ! COMMON/CDF/ IES,LF,LST,NDAT,NRES,NPLT,NFAI,NMAP,NSPN,NLOG
      INCLUDE 'MXLD.H'
      INCLUDE "C.DON.H"     ! COMMON/DON/ A(MXL,MXD),IQ(MXL),IP(MXL),NB,NOEL
C      PARAMETER (ISZTA=80)
C      CHARACTER(ISZTA) TA
C      PARAMETER (MXTA=45)
      INCLUDE "C.DONT.H"     ! COMMON/DONT/ TA(MXL,MXTA)
      INCLUDE "C.REBELO.H"   ! COMMON/REBELO/ NRBLT,IPASS,KWRT,NNDES,STDVM
      INCLUDE "C.RIGID.H"     ! COMMON/RIGID/ BORO,DPREF,HDPRF,DP,QBR,BRI
      INCLUDE 'MXFS.H'
      INCLUDE 'MXSCL.H'
      INCLUDE "C.SCAL.H"     ! COMMON/SCAL/ SCL(MXF,MXS,MXSCL),TIM(MXF,MXS),NTIM(MXF),KSCL
      INCLUDE "C.SCALP.H"     ! COMMON/SCALP/ VPA(MXF,MXP),JPA(MXF,MXP)
      PARAMETER (LBLSIZ=20)
      PARAMETER (KSIZ=10)
      CHARACTER(KSIZ) FAM
      CHARACTER(LBLSIZ) LBF
      INCLUDE "C.SCALT.H"     ! COMMON/SCALT/ FAM(MXF),LBF(MXF,MLF)
 
      LOGICAL IDLUNI
 
      PARAMETER (ND=70000)
      DIMENSION XM(ND), YM(ND), freq(nd), ekin(nd), turn(nd)
 
      CHARACTER(15) OPT(2)
      DIMENSION MODSCV(MXF),MODSCL(MXF)
      SAVE MODSCL
 
      DIMENSION SCL2(MXF,MXD), TIM2(MXF,MXD), NTIM2(MXF)
      DIMENSION SCL2I(MXF,MXD), TIM2I(MXF,MXD), NTIM2I(MXF)
      SAVE NTIM2, SCL2, TIM2
 
      INTEGER DEBSTR, FINSTR
      SAVE NFAM
 
      CHARACTER(132)  TFILE(MXTA), TXTF
      SAVE TFILE
      LOGICAL OK, SCALEX

      PARAMETER (MSTR=MLF+1)
      CHARACTER(LBLSIZ) STRA(MSTR)

      DATA OPT/ '-- Now OFF --',' ' /
 
      NP = 1
      IOPT = NINT(A(NOEL,NP))
      NP = NP + 1
      NFAM = NINT(A(NOEL,NP))
      OK=SCALEX(TA(NOEL,MXTA)(121:125) .EQ. 'PRINT') 
      KSCL=0
      IF(IOPT*NFAM.NE.0)  KSCL=1

      IF(NRES .GT. 0) WRITE(NRES,100) NFAM, OPT(IOPT+1)
 100  FORMAT(/,15X,'Scaling  request  on',I3
     >,'  families  of  optical  elements :',/,T40,A)
 
      IF(IOPT .EQ. 0) RETURN
 
      DO 1 IF=1,NFAM
 
C FM Jan 2017
        FAM(IF) = TA(NOEL,IF)(1:KSIZ)
c        FAM(IF) = TA(NOEL,IF)(1:KSIZ)
C FM July 2014. For compatibility with combined FIT+REBELOTE
        NP = NP + 1
        NTIM(IF) = NINT(A(NOEL,NP))
 
        CALL STRGET(TA(NOEL,IF),MSTR,
     >                               NSTR,STRA)
        NLF = NSTR-1
        IF(NLF .GT. MLF) CALL ENDJOB(
     >  'SBR scalin. Prblm with LBF size... Should be < ',NLF)
        II = KSIZ+2
        IF(NSTR .GE. 2) THEN
          DO  KL=1,NLF
            IF(KL+1 .GT. MSTR) THEN
              CALL ENDJOB(' Pgm scalin, error : KL+1 > MSTR.',-99)
            ENDIF
            LBF(IF,KL) =  STRA(KL+1)
          ENDDO
        ENDIF 

        IF(NRES .GT. 0) THEN
 
          WRITE(NRES,FMT='(/,5X,''Family number  '',I2)') IF
          WRITE(NRES,101) NLF,FAM(IF)(DEBSTR(FAM(IF)):FINSTR(FAM(IF)))
 101      FORMAT(10X,'Element [/label(s) (',I2,')] to be scaled :'
     >    ,T60,A)

          IF(NLF .EQ. 0) THEN
             WRITE(NRES,FMT='(15X,
     >       ''Family not labeled ;  this scaling will apply'',
     >       '' to all (unlabeled) elements  "'',A,''"'')') FAM(IF)
          ELSE
            WRITE(NRES,FMT='(T60,''/'',A)')
     >      (LBF(IF,KL)(DEBSTR(LBF(IF,KL)):FINSTR(LBF(IF,KL))),KL=1,NLF)
          ENDIF

          IF(JPA(IF,MXP).GT.0 .AND. JPA(IF,1).GT.0) THEN
            WRITE(NRES,FMT='(15X,''List of the '',I2
     >      ,'' parameters to be scaled in these elements : ''
     >      ,20(I2,'','',1X))') JPA(IF,MXP),(JPA(IF,I),I=1,JPA(IF,MXP))
            WRITE(NRES,FMT='(15X,''Their scaling factor : '', 1P
     >      ,20(E17.8,1X))') (A(NOEL,NP+I),I=1,JPA(IF,MXP))
          ENDIF
 
        ENDIF
 
        IF(NTIM(IF) .GE. 0) THEN
 
          IF    (MODSCL(IF) .LT. 10) THEN
 
            NP = NP + 1
            DO IT = 1, NTIM(IF)
               SCL(IF,IT,1) = A(NOEL,NP+IT-1)
               TIM(IF,IT) = A(NOEL,NP+NTIM(IF)+IT-1)

            ENDDO
            NP = NP +  2 * NTIM(IF)
 
          ELSEIF(MODSCL(IF) .GE. 10) THEN
 
            IF(IPASS.EQ.1) THEN
 
              DO IT = 1, NTIM(IF)
                 DO I=1, 10
                    SCL(IF,IT,I) = SCL(IF,IT,I) * SCL(IF,MXS,1)
                 ENDDO
              ENDDO
 
            ENDIF
 
            IF(MODSCL(IF) .EQ. 11) THEN
 
              IF(IPASS.EQ.1) THEN
 
                IIT = NTIM2(IF)
                DO IT = 1, IIT
                   SCL2(IF,IT) = A(NOEL,NP+IT)
                   TIM2(IF,IT) = A(NOEL,NP+NTIM2(IF)+IT)
                ENDDO
                NP = NP +  2 * IIT
 
                IF(IIT.EQ.1 .AND. TIM2(IF,1).EQ.0.D0)
     >                         TIM2(IF,1) =  BORO
 
                DUM = SCALE2(SCL2,TIM2,NTIM2,IF)
 
              ENDIF
            ENDIF
 
          ENDIF
 
          IF(NRES .GT. 0) THEN
 
            IF(MODSCL(IF) .LT. 10) THEN
 
              WRITE(NRES,102) NTIM(IF), (SCL(IF,IT,1) ,IT=1,NTIM(IF))
 102          FORMAT(20X,' # TIMINGS :', I2
     >          ,/,20X,' SCALING   : ',10(F16.8,1X))
              WRITE(NRES,103) (NINT(TIM(IF,IT)), IT=1,NTIM(IF))
 103          FORMAT(20X,' TURN #    : ',10(I12,1X))
 
            ELSEIF(  MODSCL(IF) .LE. 12) THEN
 
              WRITE(NRES,104)
     >        TFILE(IF)(DEBSTR(TFILE(IF)):FINSTR(TFILE(IF))),
     >        NTIM(IF), TIM(IF,1), TIM(IF,NTIM(IF)),
     >        SCL(IF,1,1), SCL(IF,NTIM(IF),1)
 104          FORMAT(15X,'Scaling of field follows the law'
     >        ,' function of Rigidity taken from file : ', A
     >        ,/,20X,' # TIMINGS : ', I5, 1P
     >        ,/,20X,' From :      ', E14.6, ' To ', E14.6, ' kG.cm'
     >        ,/,20X,' Scal from : ', E14.6, ' To ', E14.6)
 
              IF    (MODSCL(IF) .EQ. 10) THEN
                WRITE(NRES,FMT='(10X,
     >          ''Scaling law from file is further multiplied by ''
     >          ,''constant factor = '',1P,E17.8)') SCL(IF,MXS,1)
 
              ELSEIF(MODSCL(IF) .EQ. 11) THEN
                WRITE(NRES,FMT='(10X,
     >          ''Scaling law from file is further multiplied by ''
     >          ,''Brho-dependent scaling SCL2'')')
 
              ENDIF
 
            ELSEIF(  MODSCL(IF) .EQ. 13) THEN
              WRITE(NRES,105)
     >        TFILE(IF)(DEBSTR(TFILE(IF)):FINSTR(TFILE(IF))),
     >        NTIM(IF), TIM(IF,1), TIM(IF,NTIM(IF)),
     >        SCL(IF,1,1), SCL(IF,NTIM(IF),1)
 105          FORMAT(15X,'Scaling of field follows the law'
     >        ,' function of Time taken from file : ', A
     >        ,/,20X,' # TIMINGS : ', I5, 1P
     >        ,/,20X,' From :      ', E14.6, ' To ', E14.6, ' s    '
     >        ,/,20X,' Scal from : ', E14.6, ' To ', E14.6)
 
            ENDIF
 
          ENDIF
 
        ELSEIF(NTIM(IF) .EQ. -1) THEN
C--------- Scaling is taken from CAVITE (ENTRY CAVIT1)
C          Starting value is either SCL(IF,1) or BORO
 
          NPA = JPA(IF,MXP)
          DO J = 1, NPA
            NP = NP+1
            VPA(IF,J) = A(NOEL,NP)
          ENDDO
 
          NP = NP + 1
          SCL(IF,1,1) = A(NOEL,NP)
          NP = NP + 1
          DUM = A(NOEL,NP)  ! TIM
          NP = NP + 1
 
          IF(NRES .GT. 0) THEN
            WRITE(NRES,FMT='(15X,''Scaling of fields follows ''
     >      ,''increase of rigidity taken from CAVITE, ''
     >      ,''starting scaling value ''
     >      ,1P,E17.8)') SCL(IF,1,1)
          ENDIF
 
        ELSEIF(NTIM(IF) .EQ. -2) THEN
C--------- Field law for scaling FFAG, LPSC, Sept. 2007
            NDSCL=1
            NDTIM=1
 
          IF(IPASS.EQ.1) THEN
            IF(IDLUNI(
     >                LUN)) THEN
              OPEN(UNIT=LUN,
     >            FILE='zgoubi.freqLaw.In',STATUS='OLD',ERR=597)
            ELSE
              WRITE(NRES,*) ' Tried  to  open  zgoubi.freqLaw.In...'
              GOTO 596
            ENDIF
 
            I = 1
 11         CONTINUE
C Array XM must be  increasing function of index
C              READ(LUN,*,ERR=599,END=598) XM(I),YM(I)
C Read                 turn#,  freq,   phi,   oclock, Ekin
              READ(LUN,*,ERR=599,END=598)
     >                 turn(i),freq(i),YM(I), XM(I),  ekin(i)
              IF(I.GT.ND) CALL ENDJOB(' SBR SCALIN, too many data. '
     >        //'Max allowed is ND = ',ND)
c              WRITE(88,fmt='(1p,4e14.6,2x,a)') turn,freq, yM(I), xM(I),
c     >                   '  sbr scalin turn freq phase oclock '
              I = I+1
            GOTO 11

 598        WRITE(6,FMT='(/,A,I8)') ' Pgm scalin. READ file '
     >      //'zgoubi.freqLaw.In ended upon EOF,'
     >      //' number of data read is ',I-1
            GOTO 21
 599        WRITE(6,*) ' Pgm scalin. READ file zgoubi.freqLaw.In ended '
     >      //'upon ERROR, number data read is ',I-1
            GOTO 21
 
 21         CONTINUE
 
            N = I-1
            WRITE(6,*) 'Number of data to be interpolated :  N= ',N
            WRITE(6,FMT='(/,/)') 
            IF(N.EQ.0) CALL ENDJOB(
     >      'Pgm scalin. Found no data to be interpolated. Leaving.'
     >      ,-99)
 
            IF(XM(2).LT.XM(1)) CALL ENDJOB(
     >      'Pgm scalin. Array X must be an increasing function '
     >      //'of index. Fix it...',-99)
 
            DUM = SCALE6(XM,YM,turn,freq,ekin,N)
 
          ENDIF
 
        ELSEIF(NTIM(IF) .EQ. -60) THEN
C--------- Scaling is taken from CAVITE (ENTRY CAVIT1)
C          Starting value is SCL(IF,1)
            NDSCL=1
            NDTIM=1
 
          NP = NP + 1
          SCL(IF,1,1) = A(NOEL,NP)
 
          IF(NRES .GT. 0) THEN
            WRITE(NRES,FMT='(15X,''Scaling of fields follows ''
     >      ,''increase of rigidity taken from CAVITE'')')
            WRITE(NRES,FMT='(15X,''Starting scaling value is ''
     >      ,1P,E17.8)') SCL(IF,1,1)
          ENDIF
 
        ELSEIF(NTIM(IF) .EQ. -77) THEN
C--------- Field law proton driver, FNAL, Nov.2000
C          SCL(IF,1) = A(NOEL,10*IF)
C          SCL(IF,2) = A(NOEL,10*IF+1)
C          SCL(IF,3) = A(NOEL,10*IF+2)
C          SCL(IF,4) = A(NOEL,10*IF+3)
C          TIM(IF,1) = A(NOEL,10*IF+4)
C          TIM(IF,2) = A(NOEL,10*IF+5)
            NDSCL=4
            NDTIM=2
          NP = NP + 1
          SCL(IF,1,1) = A(NOEL,NP)
          NP = NP + 1
          SCL(IF,2,1) = A(NOEL,NP)
          NP = NP + 1
          SCL(IF,3,1) = A(NOEL,NP)
          NP = NP + 1
          SCL(IF,4,1) = A(NOEL,NP)
          NP = NP + 1
          TIM(IF,1) = A(NOEL,NP)
          NP = NP + 1
          TIM(IF,2) = A(NOEL,NP)
          IF(NRES .GT. 0) THEN
            WRITE(NRES,112) (SCL(IF,IC,1) ,IC=1,4)
 112        FORMAT(20X,' Brho-min, -max, -ref,  Frep  : ', 4(F17.8,1X))
            WRITE(NRES,113) ( INT(TIM(IF,IT)), IT=1,2)
 113        FORMAT(20X,' TURN #    : ',I12,'  TO  ',I12)
          ENDIF
 
        ELSEIF(NTIM(IF) .EQ. -88) THEN
C--------- AC dipole at  BNL
          NDSCL=4
          NDTIM=4
          NP = NP + 1
          SCL(IF,1,1) = A(NOEL,NP)     ! phase of the ac dipole
          NP = NP + 1
          SCL(IF,2,1) = A(NOEL,NP)     ! Q1, tune at the start of the sweep
          NP = NP + 1
          SCL(IF,3,1) = A(NOEL,NP)     ! Q2, tune at the end of the sweep
          NP = NP + 1
          SCL(IF,4,1) = A(NOEL,NP)     ! scale factor
          NP = NP + 1
          TIM(IF,1) = A(NOEL,NP)     ! Hold number of turns (at zero)
          NP = NP + 1
          TIM(IF,2) = A(NOEL,NP)     ! Ramp up number of turns
          NP = NP + 1
          TIM(IF,3) = A(NOEL,NP)     ! Sweep number of turns
          NP = NP + 1
          TIM(IF,4) = A(NOEL,NP)     ! Ramp down number of turns
          NP = NP + 1
          IF(NRES .GT. 0) THEN
            WRITE(NRES,
     >          FMT='(5X,1P,''Phase, Q1, Q2, Scale'',4(1X,E14.6))') 
     >          (SCL(IF,IC,1) ,IC=1,4)
            WRITE(NRES,
     >          FMT='(5X,'' N-hold, -up , -sweep, -down : '',3I8)') 
     >          (NINT(TIM(IF,IT)), IT=1,4)
          ENDIF

C        ELSEIF(NTIM(IF) .EQ. -88) THEN
CC--------- AC dipole at  BNL
CC          SCL(IF,1) = A(NOEL,10*IF)       ! C
CC          SCL(IF,2) = A(NOEL,10*IF+1)     ! Q1
CC          SCL(IF,3) = A(NOEL,10*IF+2)     ! Q2
CC          SCL(IF,4) = A(NOEL,10*IF+3)     ! P
CC          TIM(IF,1) = A(NOEL,10*IF+4)     ! Nramp
CC          TIM(IF,2) = A(NOEL,10*IF+5)     ! Nflat
CC          TIM(IF,3) = A(NOEL,10*IF+6)     ! Ndown
C            NDSCL=4
C            NDTIM=3
C          NP = NP + 1
C          SCL(IF,1,1) = A(NOEL,NP)      ! C
C          NP = NP + 1
C          SCL(IF,2,1) = A(NOEL,NP)     ! Q1
C          NP = NP + 1
C          SCL(IF,3,1) = A(NOEL,NP)     ! Q2
C          NP = NP + 1
C          SCL(IF,4,1) = A(NOEL,NP)     ! P
C          NP = NP + 1
C          TIM(IF,1) = A(NOEL,NP)     ! Nramp
C          NP = NP + 1
C          TIM(IF,2) = A(NOEL,NP)     ! Nflat
C          NP = NP + 1
C          TIM(IF,3) = A(NOEL,NP)     ! Ndown
C          NP = NP + 1
C          IF(NRES .GT. 0) THEN
C            WRITE(NRES,FMT='(5X,1P,''C, Q1, Q2, P :'',4(1X,E14.6))')
C     >          (SCL(IF,IC,1) ,IC=1,4)
C            WRITE(NRES,FMT='(5X,'' N-ramp, -flat, -down : '',3I8)')
C     >          (NINT(TIM(IF,IT)), IT=1,3)
C          ENDIF
 
        ELSEIF(NTIM(IF) .EQ. -87) THEN
C AGS Q-jump quads.
C--------- Scaling is taken from CAVITE (ENTRY CAVIT1), as for NTIM=-1.
C          Starting value is SCL(IF,1).
C          Switch-on is triggered by G.gamma value : trigger is at G.gamma=Integer+dN (dN=0.75-frac(Qx),
C                with normally frac(Qx)~0.73 hence dN~0.25)
C          SCL(IF,1) = A(NOEL,10*IF)
C          TIM(IF,1) = A(NOEL,10*IF+1)     ! G.gamma value at start of jump
C          TIM(IF,2) = A(NOEL,10*IF+2)     ! dN
C          TIM(IF,3) = A(NOEL,10*IF+3)     ! # of turns on up and on down ramps (~40)
            NDSCL=1
            NDTIM=3
          NP = NP + 1
          SCL(IF,1,1) = A(NOEL,NP)
          NP = NP + 1
          TIM(IF,1) = A(NOEL,NP)     ! G.gamma value at start of jump
          NP = NP + 1
          TIM(IF,2) = A(NOEL,NP)     ! dN
          NP = NP + 1
          TIM(IF,3) = A(NOEL,NP)     ! # of turns on up and on down ramps (~40)
 
          IF(NRES .GT. 0) THEN
            WRITE(NRES,FMT='(15X,''Scaling of field in Q-jump quads ''
     >      ,''follows increase of rigidity taken from CAVITE'')')
            WRITE(NRES,FMT='(15X,''Starting scaling value is ''
     >      ,1P,E17.8)') SCL(IF,1,1)
            WRITE(NRES,FMT='(5X,
     >      ''Quad jump series is started at G.gamma = N + dN ='',
     >      F10.4,'' + '',F10.4)') TIM(IF,1),TIM(IF,2)
            WRITE(NRES,FMT=
     >      '(5X,''Number of turns of up- and down-ramps is : '',I4)')
     >      NINT(TIM(IF,3))
 
          ENDIF
 
        ENDIF
 
 1    CONTINUE
 
      RETURN
 
 597  CONTINUE
      WRITE(6,FMT='(3A)') 'Pgm scalin. Could not open file ',
     > 'zgoubi.freqLaw.In','.  Check existence...'
      CALL ENDJOB('Pgm scalin. Leaving.',-99)
 596  CONTINUE
      WRITE(6,FMT='(3A)') 'Pgm scalin. Could not get idle unit number '
     >//'for opening file','zgoubi.freqLaw.In','.  Check pgm scalin.'
      CALL ENDJOB('Pgm scalin. Leaving.',-99)
      RETURN
 
      ENTRY SCALI4(
     >             SCL2I,TIM2I,NTIM2I,JF)
      NTIM2(JF) = NTIM2I(JF)
      DO IT = 1, NTIM2(JF)
        SCL2(JF,IT) = SCL2I(JF,IT)
        TIM2(JF,IT) = TIM2I(JF,IT)
      ENDDO
      RETURN
 
      ENTRY SCALI6(MODSCV)
      DO I = 1, MXF
        MODSCL(I) = MODSCV(I)
      ENDDO
      RETURN
 
      ENTRY SCALI5(
     >              MODSCV,NFAMO)
      NFAMO = NFAM
      DO I = 1, MXF
        MODSCV(I) = MODSCL(I)
      ENDDO
      RETURN
 
      ENTRY SCALI8(
     >             TXTF, IFAM)
      IF(IFAM.GT.MXTA) CALL ENDJOB 
     >('SBR scalin. Too many files. Max is ',MXTA)
      TFILE(IFAM) = TXTF
      RETURN
 
      END
