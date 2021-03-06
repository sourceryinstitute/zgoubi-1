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

      INTEGER MXF, MXS, MLF, MXP

C------ MXF=max number of families that can be declared in SCALING
C       MXS=max number of timings. *** Attention : make sure MXS .le. MXD

C      PARAMETER (MXF=9,MXS=100)

C AGS modeling requires 18 scaling factors (XQH, XQV, XSH, XSV, a16_19_blw_I  etc.). 
C AGS model including acceleration observed to require up to 2617 timings
C *** Attention : MXS .le. MXD

!!!!! If change MXF, then change MXTA to same value in "PARAMETER (MXTA=??)" in fortran files
      PARAMETER (MXF=45,MXS=2000) 

C------ MLF=max number of labels following a family name in SCALING
      PARAMETER(MLF=9)

C------ MXP=1+max number of parameters in elements with ad hoc label, 
C e.g., 10 parameters, from # 4 to # 13, for the 10 pole field values in MULTIPOL 
      PARAMETER(MXP=11)
