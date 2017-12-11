cwlVersion: v1.0
class: Workflow

inputs:
  infile: File
  nobary: boolean
  dm: float
  numout: int
  time: float

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


$namespaces:
  s: http://schema.org/
$schemas:
  - https://schema.org/docs/schema_org_rdfa.html

s:license: "https://mit-license.org/"
s:author:
  s:person.url: "http://orcid.org/0000-0002-6136-3724"


