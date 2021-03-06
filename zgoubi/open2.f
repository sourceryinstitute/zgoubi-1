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
      SUBROUTINE OPEN2(SBR,LUN,NOMFIC)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      CHARACTER(*) SBR, NOMFIC
      INCLUDE "C.CDF.H"     ! COMMON/CDF/ IES,LF,LST,NDAT,NRES,NPLT,NFAI,NMAP,NSPN,NLOG
      INCLUDE "C.REBELO.H"   ! COMMON/REBELO/ NRBLT,IPASS,KWRT,NNDES,STDVM
      CHARACTER(80) TITRE
 
      CHARACTER(80) NAMFIC
      INTEGER DEBSTR,FINSTR
      LOGICAL OPN, IDLUNI, BINARY
      CHARACTER(12) TXT
      CHARACTER(320) TXTN80, TXTA80, TXTB80,TXT80
      CHARACTER(10) DMY
      CHARACTER(9) HMS
      SAVE BINARY
      INCLUDE 'FILHDF.H'     ! PARAMETER (NHDFL=4)

C... ATTENTION: UNITES LOGIQUES 10... RESRVEES CARTES DE Champ 3D

      CALL ZGTITR(
     >            TITRE)
 
      NAMFIC=NOMFIC(DEBSTR(NOMFIC):FINSTR(NOMFIC))
      INQUIRE(FILE=NAMFIC,ERR=98,OPENED=OPN,NUMBER=LN)

      BINARY=NAMFIC(1:2).EQ.'B_' .OR. NAMFIC(1:2).EQ. 'b_'
        
      IF(OPN) THEN
         IF(NRES.GT.0)
     >   WRITE(NRES,FMT='(/,5X,A,/,5X,'' already open...'')')NAMFIC
         IF(LN .NE. LUN) CALL ENDJOB('Pgm open2. Mixing up logival unit'
     >   //'numb. of output files !',-99)
      ELSE
        IF(IDLUNI(
     >            LUN)) THEN
          IF(.NOT.BINARY) THEN
            OPEN(UNIT=LUN,FILE=NAMFIC,ERR=99)
            CLOSE(UNIT=LUN,STATUS='DELETE')
            OPEN(UNIT=LUN,FILE=NAMFIC,ERR=99)
          ELSE
            OPEN(UNIT=LUN,FILE=NAMFIC,FORM='UNFORMATTED',ERR=99)
            CLOSE(UNIT=LUN,STATUS='DELETE')
            OPEN(UNIT=LUN,FILE=NAMFIC,FORM='UNFORMATTED',ERR=99)
          ENDIF
        ELSE
         CALL ENDJOB('Pgm open2. Could not get logical unit number to'
     >   //' open file '//TRIM(NAMFIC),-99)            
        ENDIF

C FM. Nov 2013. Re-arranged here for compatibilty wit OPTIONS[WRITE ON/OFF]
C          IF(NRES .GT. 0) THEN
C        IF(IPASS .EQ. 1) THEN
          IF(SBR .EQ. 'CHXC') TXT='TRAJECTORIES'
          IF(SBR .EQ. 'CHXP') TXT='TRAJECTORIES'
          IF(SBR .EQ. 'FAISCN') TXT='COORDINATES'
          IF(SBR .EQ. 'FMAPW') TXT='FIELD MAP'
          IF(SBR .EQ. 'MAIN') TXT='TRAJECTORIES'
          IF(SBR .EQ. 'SPNPRN') TXT='SPIN DATA'
          IF(SBR .EQ. 'SRPRN') TXT='S.R. DATA'
          TXT80 = ' ' 
          IF(SBR .EQ. 'SRPRN') WRITE(TXT80,FMT='(15X,
     >    ''Particle #   Total # photons   Total E-loss (keV)'')')
          CALL DATE2(DMY)
          CALL TIME2(HMS)
          IF(NRES .GT. 0) WRITE(NRES,100) NAMFIC,TXT
 100      FORMAT(/,15X,' OPEN FILE ',A,/,15X,' FOR PRINTING ',A,/)

C            IF(IPASS .EQ. 1) THEN
C------------- Write down a 4-line header
          WRITE(TXT80,FMT='(''# '',A,'' - STORAGE FILE, '',A,1X,A)')
     >                                                TXT,DMY,HMS
          IF    (TXT.EQ.'TRAJECTORIES') THEN
            TXTN80 = 
     >      '#  1 ,  2   , 3 ,  4 , 5 ,  6 , 7 ,  8  ,  9   , 10  ,'
     >      //'  11, 12,  13, 14, 15  , 16  , 17,  18 , 19 ,'
     >      //' 20  ,  21 , 22, 23, 24, 25,  26  ,  27  ,  28  ,'
     >      //'   29 ,  30 , 31  , 32   ,  33  ,  34 ,  35 , 36  ,'
     >      //'  37, 38 , 39 ,  40  , 41   , 42  ,'
     >      //'   43  , 44    , 45    ,   46 '
            TXTA80 = 
     >      '# KEX,  Do-1, Yo,  To, Zo,  Po, So,   to,   D-1, Y-DY,'
     >      //'   T,  Z,   P,  S, time, beta, DS, KART,  IT,'
     >      //' IREP, SORT,  X, BX, BY, BZ,   RET,   DPR,    PS,'
     >      //'   SXo,  SYo,  SZo, modSo,    SX,   SY,   SZ, modS,'
     >      //'  EX,  EY,  EZ,  BORO, IPASS, NOEL,'
     >      //'   KLEY, LABEL1, LABEL2,    LET'
            TXTB80 = 
     >      '# int, float, cm, mrd, cm, mrd, cm, mu_s, float,   cm,'
     >      //' mrd, cm, mrd, cm, mu_s,  v/c, cm,  int, int,'
     >      //'  int,   cm, cm, kG, kG, kG, float, float, float,'
     >      //' float,float,float, float, float,float,float,float,'
     >      //' V/m, V/m, V/m, kG.cm,   int,  int,'
     >      //' string, string, string, string'

          ELSEIF(TXT.EQ.'COORDINATES') THEN
            TXTN80 = 
     >      '#  1 ,  2   , 3 ,  4 , 5 , 6  , 7 ,  8  ,  9   , 10,'
     >      //'  11, 12,  13, 14, 15  ,'
     >      //'   16 ,  17 ,  18 , 19   ,  20  ,  21 ,  22 ,  23 ,'
     >      //'   24   ,  25  ,'
     >      //'  26,  27 , 28  ,   29  ,30,  31  ,   32 , unused,'
     >      //'   34 ,   35 ,'
     >      //'    36,  37  , 38   , 39  ,  40   ,'
     >      //'  41/lbl1, 42/lbl2,  43 ,  44      45             46'
            TXTA80 = 
     >      '# KEX,  Do-1, Yo,  To, Zo,  Po, So,   to,   D-1,  Y,'
     >      //'   T,  Z,   P,  S, time,'
     >      //'   SXo,  SYo,  SZo, modSo,    SX,   SY,   SZ, modS,'
     >      //'   ENEKI, ENERG,'
     >      //'  IT, IREP, SORT,      M, Q,     G,   tau, unused,'
     >      //'   RET,   DPR,'
     >      //'    PS,  BORO, IPASS, NOEL,   KLEY,'
     >      //'  LABEL1, LABEL2,    LET,  SRloss, DPREF-[DPREF],'
     >      //'[DPREF], '
            TXTB80 = 
     >      '# int, float, cm, mrd, cm, mrd, cm, mu_s, float, cm,'
     >      //' mrd, cm, mrd, cm, mu_s,'
     >      //' float,float,float, float, float,float,float,float,'
     >      //'     MeV,   MeV,'
     >      //' int,  int,   cm, MeV/c2, C, float, float,  float,'
     >      //' float, float,'
     >      //' float, kG.cm,   int,  int, string,'
     >      //'  string, string, string,  MeV             '

          ELSEIF(TXT.EQ.'SPIN DATA') THEN
            TXTN80 = 
     >      '#  1 ,'
     >      //'   2  ,  3  ,  4  ,  5   ,  6   ,  7  ,  8  ,  9  ,'
     >      //' 10, 11  , 12   , 13  , 14   , 15  ,'
     >      //'  16   ,  17   ,  18   ,   19  '
            TXTA80 = 
     >      '# KEX,'
     >      //'   SXo,  SYo,  SZo, modSo,    SX,   SY,   SZ, modS,'
     >      //'  s, Ekin, Itraj, IMAX, IPASS, NOEL,'
     >      //'   KLEY, LABEL1, LABEL2,    LET'
            TXTB80 = 
     >      '# int,'
     >      //' float,float,float, float, float,float,float,float,'
     >      //' cm,  MeV,   int,  int,   int,  int,'
     >      //' string, string, string, string'

          ELSE
            TXTN80 = '# ...'
            TXTA80 = '# ...'
            TXTB80 = '# ...'
          ENDIF

          NHD = 0
          IF(.NOT.BINARY) THEN
            TXT80 = TXT80(debstr(TXT80):finstr(TXT80))//'. '//TITRE
            WRITE(LUN,FMT='(A)') TXT80
            NHD = NHD+1
            WRITE(LUN,FMT='(A)') TXTN80
            NHD = NHD+1
            WRITE(LUN,FMT='(A)') TXTA80
            NHD = NHD+1
            WRITE(LUN,FMT='(A)') TXTB80
            NHD = NHD+1
          ELSE
            TXT80=TXT80(debstr(TXT80):finstr(TXT80))//'. '//TITRE
            WRITE(LUN) TXT80
            NHD = NHD+1
            WRITE(LUN) TXTN80
            NHD = NHD+1
            WRITE(LUN) TXTA80
            NHD = NHD+1
            WRITE(LUN) TXTB80
            NHD = NHD+1
          ENDIF
          IF(NHD .GT. NHDFL) CALL ENDJOB('Pgm open2. Please increase '//
     >    'value of parameter NHDFL=number of header lines, now ',NHDFL)

C       ENDIF ! ipass.eq.1
      ENDIF

      IF(TXT.EQ.'TRAJECTORIES') CALL IMPPL2(BINARY)

C        ENDIF
C------- OPN

      RETURN
 
 98   IF(NRES .GT. 0) WRITE(NRES,101) SBR,' INQUIRE ',NAMFIC
 101  FORMAT(/,' ******  SBR ',A,' : ERROR',2A,/)
      RETURN

 99   IF(NRES .GT. 0) WRITE(NRES,101) SBR,' OPEN ',NAMFIC
      RETURN
      END
