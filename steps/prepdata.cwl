# $  prepdata
# 
#    [-ncpus ncpus] -o outfile [-filterbank] [-psrfits] [-noweights] [-noscales]
#    [-nooffsets] [-window] [-if ifs] [-clip clip] [-noclip] [-invert] [-zerodm]
#    [-nobary] [-shorts] [-numout numout] [-downsamp downsamp] [-offset offset]
#    [-start start] [-dm dm] [-mask maskfile] [-ignorechan ignorechanstr] [--]
#    infile ...
#       Prepares a raw data file for pulsar searching or folding (conversion,
#       de-dispersion, and barycentering).
#          -ncpus: Number of processors to use with OpenMP
#                  1 int value between 1 and oo
#                  default: `1'
#              -o: Root of the output file names
#                  1 char* value
#     -filterbank: Raw data in SIGPROC filterbank format
#        -psrfits: Raw data in PSRFITS format
#      -noweights: Do not apply PSRFITS weights
#       -noscales: Do not apply PSRFITS scales
#      -nooffsets: Do not apply PSRFITS offsets
#         -window: Window correlator lags with a Hamming window before FFTing
#             -if: A specific IF to use if available (summed IFs is the default)
#                  1 int value between 0 and 1
#           -clip: Time-domain sigma to use for clipping (0.0 = no clipping, 6.0 = default
#                  1 float value between 0 and 1000.0
#                  default: `6.0'
#         -noclip: Do not clip the data.  (The default is to _always_ clip!)
#         -invert: For rawdata, flip (or invert) the band
#         -zerodm: Subtract the mean of all channels from each sample (i.e. remove zero DM)
#         -nobary: Do not barycenter the data
#         -shorts: Use short ints for the output data instead of floats
#         -numout: Output this many values.  If there are not enough values in the
#                  original data file, will pad the output file with the average
#                  value
#                  1 long value between 1 and oo
#       -downsamp: The number of neighboring bins to co-add
#                  1 int value between 1 and 128
#                  default: `1'
#         -offset: Number of spectra to offset into as starting data point
#                  1 long value between 0 and oo
#                  default: `0'
#          -start: Starting point of the processing as a fraction of the full obs
#                  1 double value between 0.0 and 1.0
#                  default: `0.0'
#             -dm: The dispersion measure to de-disperse (cm^-3 pc)
#                  1 double value between 0 and oo
#                  default: `0'
#           -mask: File containing masking information to use
#                  1 char* value
#     -ignorechan: Comma separated string (no spaces!) of channels to ignore (or
#                  file containing such string).  Ranges are specified by
#                  min:max[:step]
#                  1 char* value
#          infile: Input data file name.  If the data is not in a known raw format,
#                  it should be a single channel of single-precision floating point
#                  data.  In this case a '.inf' file with the same root filename
#                  must also exist (Note that this means that the input data file
#                  must have a suffix that starts with a period)
#                  1...512 values
#   version: 28Jun17

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [prepdata]

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.mask)
      - entry: $(inputs.stats)

hints:
  DockerRequirement:
      dockerImageId: kernsuite/presto

inputs:
  infile:
    type: File
    inputBinding:
      position: 1

  nobary:
    type: boolean?
    inputBinding:
      prefix: -nobary

  mask:
    type: File
    inputBinding:
      prefix: -mask

  stats:
    type: File

  dm:
    type: float?
    doc: The dispersion measure to de-disperse (cm^-3 pc)
    inputBinding:
      prefix: -dm

  numout:
    type: int?
    inputBinding:
       prefix: -numout
 

arguments:
  - prefix: -o
    valueFrom: $(inputs.infile.nameroot)

outputs:
  dat:
    type: File
    outputBinding:
      glob: $(inputs.infile.nameroot).dat

  inf:
    type: File
    outputBinding:
      glob: $(inputs.infile.nameroot).inf


