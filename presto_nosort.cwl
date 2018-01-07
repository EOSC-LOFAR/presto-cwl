cwlVersion: v1.0
class: Workflow

requirements:
  ScatterFeatureRequirement: {}

inputs:
  filterbank: File
  birds: File
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
  accelcand: int

outputs:
  pfds:
    type: File[]
    outputSource: prepfold/pfd

  bestprof:
    type: File[]
    outputSource: prepfold/bestprof


steps:
  rfifind:
    run: steps/rfifind.cwl
    in:
      time: time
      filterbank: filterbank
    out:
        [bytemask, inf, mask, ps, rfi, stats]

  makezaplist:
    run: steps/makezaplist.cwl
    in:
      inf: rfifind/inf
      birds: birds
    out:
      [zaplist]

  prepsubband:
    run: steps/prepsubband.cwl
    in:
      filterbank: filterbank
      mask: rfifind/mask
      stats: rfifind/stats
      nsub: nsub
      lodm: lodm
      dmstep: dmstep
      numdms: numdms
      numout: numout_prepsubband
      downsamp: downsamp
      nobary: nobary
    out: [dats, infs]

  realfft_subbands:
    run: steps/realfft.cwl
    in:
      dat: prepsubband/dats
    scatter: dat
    out:
      [fft]

  zapbirds:
    run: steps/zapbirds.cwl
    in:
      zapfile: makezaplist/zaplist
      fft: realfft_subbands/fft
      inf: prepsubband/infs 
    scatter: [fft, inf]
    scatterMethod: dotproduct
    out: [zapped]

  accelsearch_subbands:
    run: steps/accelsearch.cwl
    in:
      dat: zapbirds/zapped 
      inf: prepsubband/infs 
      numharm: numharm
      zmax: zmax
    scatter: [dat, inf]
    scatterMethod: dotproduct
    out: [candidates_binary, candidates_text]

  prepfold:
    run: steps/prepfold.cwl
    in:
      accelcand: accelcand
      accel: accelsearch_subbands/candidates_binary
      dat: sort_dats/sorted_array_of_files
      inf: prepsubband/infs 
    scatter: [accel, dat, inf]
    scatterMethod: dotproduct
    out: [pfd, bestprof]


