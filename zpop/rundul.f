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
C  Brookhaven National Laboratory                                               �s
C  C-AD, Bldg 911
C  Upton, NY, 11973
C  USA
C  -------
      SUBROUTINE RUNDUL(ND)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
C     ****************************
C     READS DATA FOR DIPOLE 'BEND'
C     ****************************
      COMMON/CDF/ IES,IORDRE,LCHA,LIST,NDAT,NRES,NPLT,NFAI,NMAP,NSPN
      INCLUDE 'MXLD.H'
      COMMON/DON/ A(MXL,MXD),IQ(MXL),IP(MXL),NB,NOEL
 
      READ(NDAT,*) IA
      A(NOEL,1) = IA
C     ... XL, BO, A, B : B = B0 * SIN(S/B) / (1+(S/A)**8)
      READ(NDAT,*) (A(NOEL,I),I=10,13)
 
      ND = 20
      READ(NDAT,*) A(NOEL,ND)
      READ(NDAT,*) IA,(A(NOEL,I),I=ND+10+1,ND+10+3)
      A(NOEL,ND+10) = IA
 
      RETURN
      END
