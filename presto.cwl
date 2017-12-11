cwlVersion: v1.0
class: Workflow

requirements:
  ScatterFeatureRequirement: {}

inputs:
  infile: File
  nobary: boolean
  dm: float
  numout: int
  time: float
  numharm: int
  zmax: int
  nsub: int
  lodm: float
  dmstep: float
  numdms: int
  numout_prepsubband: int
  downsamp: int

outputs:
  bytemask:
    type: File
    outputSource: rfifind/bytemask

  inf:
    type: File
    outputSource: rfifind/inf

  mask:
    type: File
    outputSource: rfifind/mask

  ps:
    type: File
    outputSource: rfifind/ps

  rfi:
    type: File
    outputSource: rfifind/rfi

  stats:
    type: File
    outputSource: rfifind/stats

  dat:
    type: File
    outputSource: prepdata/dat

  inf:
    type: File
    outputSource: prepdata/inf

  candidates_binary:
    type: File[]
    outputSource: accelsearch/candidates_binary

  candidates_text:
    type: File[]
    outputSource: accelsearch/candidates_text

  dats:
    type: File[]
    outputSource: prepsubband/dats

  infs:
    type: File[]
    outputSource: prepsubband/infs


  ffts:
    type: File[]
    outputSource: realfft/fft


steps:
  rfifind:
    run: steps/rfifind.cwl
    in:
      time: time
      infile: infile
    out:
        [bytemask, inf, mask, ps, rfi, stats]

  prepdata:
    run: steps/prepdata.cwl
    in:
      infile: infile
      dm: dm
      nobary: nobary
      numout: numout
      stats: rfifind/stats
      mask: rfifind/mask
    out:
       [dat, inf]

  accelsearch_birdy:
    run: steps/accelsearch.cwl
    in:
      dat: prepdata/dat
      inf: prepdata/inf
      numharm: numharm
      zmax: zmax
    out: [candidates_binary, candidates_text]

  prepsubband:
    run: steps/prepsubband.cwl
    in:
      infile: infile
      mask: rfifind/mask
      stats: rfifind/stats
      nsub: nsub
      lodm: lodm
      dmstep: dmstep
      numdms: numdms
      numout: numout_prepsubband
      downsamp: downsamp
    out: [dats, infs]

  realfft:
    run: steps/realfft.cwl
    in:
      infile: prepsubband/dats
    scatter: infile
    out:
      [fft]

  accelsearch:
    run: steps/accelsearch.cwl
    in:
      dat: realfft/fft
      inf: prepsubband/infs
      numharm: numharm
      zmax: zmax
    scatter: [dat, inf]
    scatterMethod: dotproduct
    out: [candidates_binary, candidates_text]

