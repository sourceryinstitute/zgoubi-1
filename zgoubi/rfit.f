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
C      SUBROUTINE RFIT(KLEY,IMAX,
      SUBROUTINE RFIT(KLEY,ITRMA0,
     >                     PNLTY,ITRMA,ICPTMA,FITFNL)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
C     ***************************************
C     READS DATA FOR FIT PROCEDURE WITH 'FIT'
C     ***************************************
      CHARACTER(*) KLEY
      INCLUDE "C.CDF.H"     ! COMMON/CDF/ IES,LF,LST,NDAT,NRES,NPLT,NFAI,NMAP,NSPN,NLOG
      PARAMETER (MXV=60) 
      INCLUDE "C.MIMA.H"     ! COMMON/MIMA/ DX(MXV),XMI(MXV),XMA(MXV)
      INCLUDE 'MXLD.H'
      INCLUDE "C.DON.H"     ! COMMON/DON/ A(MXL,MXD),IQ(MXL),IP(MXL),NB,NOEL
C      PARAMETER (LNTA=132) ; CHARACTER(LNTA) TA
C      PARAMETER (MXTA=45)
      INCLUDE "C.DONT.H"     ! COMMON/DONT/ TA(MXL,MXTA)
      INCLUDE "C.VARY.H"  ! COMMON/VARY/ NV,IR(MXV),NC,I1(MXV),I2(MXV),V(MXV),IS(MXV),W(MXV),
                          !     >IC(MXV),IC2(MXV),I3(MXV),XCOU(MXV),CPAR(MXV,27)

      CHARACTER(132) TXT132
      CHARACTER(20) TXT20
      LOGICAL STRCON, CMMNT, FITFNL
      CHARACTER(40) STRA(10)

      PARAMETER (ICPTM1=5000, ICPTM2=10000)
      LOGICAL FITSAV
      INTEGER DEBSTR, FINSTR
      CHARACTER(80) FNAME
      LOGICAL EMPTY
      LOGICAL FIRST 
      LOGICAL ISNUM
      PARAMETER (KSIZ=10)
      CHARACTER(KSIZ) KLE
      PARAMETER (ITXT=10)
      CHARACTER(ITXT) TXTIC

      SAVE FIRST

      DATA FIRST / .TRUE. /

      LINE = 1
C  READ NV [,'nofinal','save' [FileName],'noSYSout']
      READ(NDAT,FMT='(A)',ERR=90,END=90) TXT132
      IF(STRCON(TXT132,'!',
     >                     IIS)) TXT132 = TXT132(1:IIS-1)
      READ(TXT132,*,ERR=90,END=90) NV
      IF(NV.LT.1) RETURN

      IF(STRCON(TXT132,'noSYSout',
     >                            III)) THEN
        CALL IMPVA2(.TRUE.,.FALSE.)
        CALL IMPCT2(.TRUE.,.FALSE.)
        DUM = NMFON2
        CALL MINO14(.TRUE.)
      ENDIF

      FITFNL = .NOT. STRCON(TXT132,'nofinal',
     >                                       IIS) 
      FITSAV = STRCON(TXT132,'save',
     >                             JJS) 
      IF(FITSAV) THEN
        TXT132 = TXT132(JJS+4:FINSTR(TXT132))
        TXT132 = TXT132(DEBSTR(TXT132):FINSTR(TXT132))

        IF(.NOT. EMPTY(TXT132)) THEN
          IF(TXT132(DEBSTR(TXT132):DEBSTR(TXT132)+6).NE.'nofinal') THEN
            READ(TXT132(DEBSTR(TXT132):FINSTR(TXT132)),*,ERR=90,END=90)
     >      FNAME
          ELSE
            FNAME = 'zgoubi.FITVALS.out'
          ENDIF
        ELSE
          FNAME = 'zgoubi.FITVALS.out'
        ENDIF
        IF(FIRST) CALL FITNU6(FNAME)
        FIRST = .FALSE.  
      ENDIF
     
      DO I=1,NV
        LINE = LINE + 1
        READ(NDAT,FMT='(A)',ERR=90,END=90) TXT132
        CMMNT = STRCON(TXT132,'!',
     >                            III) 
        IF(CMMNT) THEN
          III = III - 1
        ELSE
          III = 132
        ENDIF
        IF(STRCON(TXT132(1:III),'[',
     >                              II)) THEN
C--------- New method
          READ(TXT132(1:II-1),*,ERR=90,END=90) IR(I),IS(I),XCOU(I)
          IF(STRCON(TXT132,']',
     >                      II2)) THEN
            READ(TXT132(II+1:II2-1),*,ERR=90,END=90) XMI(I),XMA(I)
          ELSE
            CALL ENDJOB(' SBR RFIT, wrong input data / variables',-99)
          ENDIF
        ELSE
C--------- Original method 
           READ(TXT132,*,ERR=90,END=90) IR(I),IS(I),XCOU(I),DX(I)
           XI = A(IR(I),IS(I))
           XMI(I)=XI-ABS(XI)*DX(I)
           XMA(I)=XI+ABS(XI)*DX(I)
        ENDIF
      ENDDO

C  READ NC [,PNLTY [,ITRMA [,ICPTMA]]]
      LINE = LINE + 1
      READ(NDAT,FMT='(A)',ERR=90,END=90) TXT132
      IF(STRCON(TXT132,'!',
     >                     III)) TXT132 = TXT132(1:III-1) 
      CALL STRGET(TXT132,3,
     >                     NSTR,STRA)
      IF(NSTR .GT. 3) NSTR = 3
      IF(NSTR.GE.1) THEN
        READ(STRA(1),*,ERR=97,END=97) NC
        IF(NSTR.GE.2) THEN
          READ(STRA(2),*,ERR=43,END=43) PNLTY
          IF(NSTR.GE.3) THEN
            READ(STRA(3),*,ERR=44,END=44) ITRMA
            IF(NSTR.EQ.4) THEN
              READ(STRA(4),*,ERR=44,END=44) ICPTMA
            ELSE
              GOTO 44
            ENDIF
          ELSE
            GOTO 42
          ENDIF
        ELSE
          GOTO 43
        ENDIF
      ENDIF
      GOTO 45
 43   CONTINUE
      PNLTY = 1.D-10
 42   CONTINUE
      ITRMA = ITRMA0
 44   CONTINUE
      IF(KLEY .EQ. 'FIT') THEN
        ICPTMA = ICPTM1
      ELSEIF(KLEY .EQ. 'FIT2') THEN
        ICPTMA = ICPTM2
      ENDIF
 45   CONTINUE

      IF(NC.LT.1) RETURN
      DO 4 I=1,NC
        LINE = LINE + 1
        READ(NDAT,FMT='(A)',ERR=90,END=90) TXT132
        IF(STRCON(TXT132,'!',
     >                     III)) TXT132 = TXT132(1:III-1) 
        IF(STRCON(TXT132,'!',
     >                     III)) TXT132 = TXT132(1:III-1) 
        READ(TXT132,*,ERR=98,END=98) XC,I1(I),I2(I),TXT20,V(I),W(I),
     >  CPAR(I,1),(CPAR(I,JJ),JJ=2,NINT(CPAR(I,1))+1)

        READ(TXT132,*,ERR=98,END=98) TXTIC

        IF(ISNUM(TXT20)) THEN
           READ(TXT20,*,ERR=90,END=90) I3(I)
        ELSE
          IF(TXT20(DEBSTR(TXT20):FINSTR(TXT20)) .EQ. '#End') THEN
            I3(I) = NOEL-1
          ELSE
            NUML = NOEL-1
            CALL GETLLB(TXT20,         ! TXT20 contains an lmnt's 1st label. Look for its first occurence
     >                        NUML)
            IF    (NUML .LE. NOEL-1) THEN 
              I3(I) = NUML
            ELSE
              WRITE(TXT132,FMT='(A,I0,A)') 
     >        ' No element found with label_1 = '
     >         //TXT20(DEBSTR(TXT20):FINSTR(TXT20))
     >         //', (FIT[2] was met at position ',NOEL,')'
              WRITE(*,FMT='(/,A)') 
     >        TXT132(DEBSTR(TXT132):FINSTR(TXT132))
              WRITE(NRES,FMT='(/,A)')
     >        TXT132(DEBSTR(TXT132):FINSTR(TXT132))
              GOTO 90
            ENDIF
          ENDIF
        ENDIF
        IC(I) = INT(XC)
        IF(STRCON(TXTIC,'.',
     >                      JS)) THEN
          IF(ISNUM(TXTIC(JS+1:ITXT)) .AND. JS .LT. ITXT) THEN
            READ(TXTIC(JS+1:ITXT),*,ERR=98,END=98) IC2(I)
          ELSE
            GOTO 98
          ENDIF
        ENDIF
 4    CONTINUE  


C----- LOOKS FOR POSSIBLE PARAMETERS, WITH VALUES IN CPAR, AND ACTION
      DO 5 I=1,NC
        IF    (IC(I).EQ.3) THEN 
C--------- TRAJ COORD
          IF    (I1(I).EQ.-1)  THEN
          ELSEIF(I1(I).EQ.-3)  THEN
            CALL DIST2W(CPAR(I,2), CPAR(I,3), CPAR(I,4))
          ELSEIF(I1(I).EQ.-4)  THEN
            CALL DISPU2(CPAR,I)
          ENDIF
        ELSEIF(IC(I).EQ.5) THEN 
C--------- Numb. particls
          IF(I1(I).GE.1) THEN
            IF(I1(I).LE.3) THEN
              CALL ACCENW(CPAR(I,2))
            ELSEIF(I1(I).LE.6) THEN
              CALL ACCEPW(CPAR(I,2))
            ENDIF
          ENDIF
        ENDIF
 5    CONTINUE  

c      DO  I=1,NC
c         write(*,*) ' rfit ',
c     >          i,ic(i),ic2(i),cpar(i,1),cpar(i,2),cpar(i,3)
c              read(*,*)
c      enddo

      RETURN

 97   write(6,*) ' Pgm rfit, error input data at NC'
 98   write(6,*) ' Pgm rfit. Constraints : wrong input data.'
      GOTO 90

 90   CONTINUE
      CALL ZGKLEY( 
     >            KLE)
      CALL ENDJOB('*** Pgm rfit, keyword '//KLE//' : '// 
     >'input data error, at line #',LINE)
      RETURN
      END
