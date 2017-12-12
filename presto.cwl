cwlVersion: v1.0
class: Workflow

requirements:
  ScatterFeatureRequirement: {}

inputs:
  infile: File
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
  candidates_text:
    type: File
    outputSource: accelsearch/candidates_text

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

  accelsearch:
    run: steps/accelsearch.cwl
    in:
      dat: prepdata/dat
      inf: prepdata/inf
      numharm: numharm
      zmax: zmax
    out: [candidates_binary, candidates_text]

  realfft:
    run: steps/realfft.cwl
    in:
      dat: prepdata/dat
    out:
      [ fft ]

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
      infile: infile
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

  sort_dats:
    run: steps/sort.cwl
    in:
      array_of_files: prepsubband/dats
    out: [ sorted_array_of_files ]

  sort_infs:
    run: steps/sort.cwl
    in:
      array_of_files: prepsubband/infs
    out: [ sorted_array_of_files ]

  realfft_subbands:
    run: steps/realfft.cwl
    in:
      dat: sort_dats/sorted_array_of_files
    scatter: dat
    out:
      [fft]

  sort_subband_ffts:
    run: steps/sort.cwl
    in:
      array_of_files: realfft_subbands/fft
    out: [ sorted_array_of_files ]

  zapbirds:
    run: steps/zapbirds.cwl
    in:
      zapfile: makezaplist/zaplist
      fft: sort_subband_ffts/sorted_array_of_files
      inf: sort_infs/sorted_array_of_files
    scatter: [fft, inf]
    scatterMethod: dotproduct
    out: [zapped]

  sort_zapped_ffts:
    run: steps/sort.cwl
    in:
      array_of_files: zapbirds/zapped
    out: [ sorted_array_of_files ]

  accelsearch_subbands:
    run: steps/accelsearch.cwl
    in:
      dat: sort_zapped_ffts/sorted_array_of_files
      inf: sort_infs/sorted_array_of_files
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
      inf: sort_infs/sorted_array_of_files
    scatter: [accel, dat, inf]
    scatterMethod: dotproduct
    out: [pfd, bestprof]


