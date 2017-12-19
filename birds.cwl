#
# we skip te exploredat and explorefft steps since they require X and are
# interactive
#
#

cwlVersion: v1.0
class: Workflow

requirements:
  ScatterFeatureRequirement: {}

inputs:
  filterbank: File
  time: float
  dm: float
  nobary: boolean
  numout: int

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
  meta:
    type: File
    outputSource: readfile/meta

  inf:
    type: File
    outputSource: rfifind/inf

  candidates_text:
    type: File
    outputSource: accelsearch/candidates_text


steps:
  readfile:
    run: steps/readfile.cwl
    in:
      filterbank: filterbank
    out:
      [meta]

  rfifind:
    run: steps/rfifind.cwl
    in:
      time: time
      filterbank: filterbank
    out:
        [bytemask, inf, mask, ps, rfi, stats]

  prepdata:
    run: steps/prepdata.cwl
    in:
      filterbank: filterbank
      dm: dm
      nobary: nobary
      numout: numout
      stats: rfifind/stats
      mask: rfifind/mask
    out:
       [dat, inf]

  realfft:
    run: steps/realfft.cwl
    in:
      dat: prepdata/dat
    out:
      [ fft ]

  accelsearch:
    run: steps/accelsearch.cwl
    in:
      dat: prepdata/dat
      inf: prepdata/inf
      numharm: numharm
      zmax: zmax
    out: [candidates_binary, candidates_text]


