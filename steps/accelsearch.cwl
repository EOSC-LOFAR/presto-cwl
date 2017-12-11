#  Search an FFT or short time series for pulsars using a Fourier domain
#  acceleration search with harmonic summing.
# 
#     [-ncpus ncpus] [-lobin lobin] [-numharm numharm] [-zmax zmax] [-sigma sigma]
#    [-rlo rlo] [-rhi rhi] [-flo flo] [-fhi fhi] [-inmem] [-photon] [-median]
#    [-locpow] [-zaplist zaplist] [-baryv baryv] [-otheropt] [-noharmpolish]
#    [-noharmremove] [--] infile
#           -ncpus: Number of processors to use with OpenMP
#                    1 int value between 1 and oo
#                    default: `1'
#            -lobin: The first Fourier frequency in the data file
#                    1 int value between 0 and oo
#                    default: `0'
#          -numharm: The number of harmonics to sum (power-of-two)
#                    1 int value between 1 and 32
#                    default: `8'
#             -zmax: The max (+ and -) Fourier freq deriv to search
#                    1 int value between 0 and 1200
#                    default: `200'
#            -sigma: Cutoff sigma for choosing candidates
#                    1 float value between 1.0 and 30.0
#                    default: `2.0'
#              -rlo: The lowest Fourier frequency (of the highest harmonic!) to
#                    search
#                    1 double value between 0.0 and oo
#              -rhi: The highest Fourier frequency (of the highest harmonic!) to
#                    search
#                    1 double value between 0.0 and oo
#              -flo: The lowest frequency (Hz) (of the highest harmonic!) to
#                    search
#                    1 double value between 0.0 and oo
#                    default: `1.0'
#              -fhi: The highest frequency (Hz) (of the highest harmonic!) to
#                    search
#                    1 double value between 0.0 and oo
#                    default: `10000.0'
#            -inmem: Compute full f-fdot plane in memory.  Very fast, but only for
#                    short time series.
#           -photon: Data is poissonian so use freq 0 as power normalization
#           -median: Use block-median power normalization (default)
#           -locpow: Use double-tophat local-power normalization (not usually
#                    recommended)
#          -zaplist: A file of freqs+widths to zap from the FFT (only if the input
#                    file is a *.[s]dat file)
#                    1 char* value
#            -baryv: The radial velocity component (v/c) towards the target during
#                    the obs
#                    1 double value between -0.1 and 0.1
#                    default: `0.0'
#         -otheropt: Use the alternative optimization (for testing/debugging)
#     -noharmpolish: Do not use 'harmpolish' by default
#     -noharmremove: Do not remove harmonically related candidates (never removed
#                    for numharm = 1)
#            infile: Input file name of the floating point .fft or .[s]dat file. 
#                    A '.inf' file of the same name must also exist
#                    1 value
#   version: 07Dec16

cwlVersion: v1.0
class: CommandLineTool
baseCommand: accelsearch

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.dat)
      - entry: $(inputs.inf)

hints:
  DockerRequirement:
    dockerImageId: kernsuite/prseto

inputs:
  dat:
    type: File
    inputBinding:
      position: 1

  inf:
    type: File

  numharm:
    type: int
    inputBinding:
      prefix: -numharm

  zmax:
    type: int
    inputBinding:
      prefix: -zmax

outputs:
  candidates_binary: 
    type: File
    outputBinding:
       glob: $(inputs.dat.nameroot)_ACCEL_0.cand

  candidates_text: 
    type: File
    outputBinding:
      glob: $(inputs.dat.nameroot)_ACCEL_0


