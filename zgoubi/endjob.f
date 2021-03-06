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
      SUBROUTINE ENDJOB(TXT,II)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      CHARACTER(*) TXT
      INCLUDE 'MXLD.H'
      INCLUDE "C.DON.H"     ! COMMON/DON/ A(MXL,MXD),IQ(MXL),IP(MXL),NB,NOEL
      INCLUDE "C.CDF.H"     ! COMMON/CDF/ IES,LF,LST,NDAT,NRES,NPLT,NFAI,NMAP,NSPN,NLOG
      INCLUDE "C.REBELO.H"   ! COMMON/REBELO/ NRBLT,IPASS,KWRT,NNDES,STDVM
      INTEGER DEBSTR, FINSTR
      LUN = ABS(NRES)
      IF(II.EQ.-99) THEN
        WRITE(6  ,FMT='( /,1X,A,//,
     >  ''  This Enjbb occured at element # '',I0,'', at pass # '',I0)') 
     >  ' '//TXT(DEBSTR(TXT):FINSTR(TXT)),NOEL,IPASS
        WRITE(LUN,FMT='( /,1X,A,//,
     >  ''  This Enjbb occured at element # '',I0,'', at pass # '',I0)') 
     >  ' '//TXT(DEBSTR(TXT):FINSTR(TXT)),NOEL,IPASS
      ELSE
        IF(II.EQ. -9999) THEN
C          WRITE(LUN,FMT='(/,''End of job !'',//,''  '')')
          WRITE(  6,FMT='(/,''End of job !'',//,''  '')')
        ELSE
          WRITE(6  ,FMT='( /,1X,A,I0,//,
     >    ''This Enjbb occured at element # '',I0,'', at pass # '',I0)') 
     >    ' '//TXT(DEBSTR(TXT):FINSTR(TXT))//' ',II,NOEL,IPASS
          WRITE(LUN,FMT='( /,1X,A,I0,//,
     >    ''This Enjbb occured at element # '',I0,'', at pass # '',I0)') 
     >    ' '//TXT(DEBSTR(TXT):FINSTR(TXT))//' ',II,NOEL,IPASS
        ENDIF
      ENDIF
      WRITE(6,201)
      WRITE(NRES,*) ' '
      WRITE(NRES,201)
      WRITE(NRES,201)
      WRITE(NRES,201)
 201  FORMAT(132('*'))
      STOP
      END
