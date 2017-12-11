# Examines radio data for narrow and wide band interference as well as problems with channels
#
# $ rfifind [-ncpus ncpus] -o outfile [-filterbank] [-psrfits] [-noweights]
#           [-noscales] [-nooffsets] [-wapp] [-window] [-numwapps numwapps]
#           [-if ifs] [-clip clip] [-noclip] [-invert] [-zerodm] [-xwin]
#           [-nocompute] [-rfixwin] [-rfips] [-time time] [-blocks blocks]
#           [-timesig timesigma] [-freqsig freqsigma] [-chanfrac chantrigfrac]
#           [-intfrac inttrigfrac] [-zapchan zapchanstr] [-zapints zapintsstr]
#           [-mask maskfile] [-ignorechan ignorechanstr] [--] infile ...

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [rfifind]

hints:
  DockerRequirement:
      dockerImageId: kernsuite/presto

inputs:
  infile:
    type: File
    inputBinding:
      position: 1

  time:
    type: float?
    inputBinding:
      prefix: -time

arguments:
  - prefix: -o
    valueFrom: $(inputs.infile.nameroot)

outputs:
  bytemask:
    type: File
    outputBinding:
      glob: $(inputs.infile.nameroot)_rfifind.bytemask

  inf:
    type: File
    outputBinding:
      glob: $(inputs.infile.nameroot)_rfifind.inf

  mask:
    type: File
    outputBinding:
      glob: $(inputs.infile.nameroot)_rfifind.mask

  ps:
    type: File
    outputBinding:
      glob: $(inputs.infile.nameroot)_rfifind.ps

  rfi:
    type: File
    outputBinding:
      glob: $(inputs.infile.nameroot)_rfifind.rfi

  stats:
    type: File
    outputBinding:
      glob: $(inputs.infile.nameroot)_rfifind.stats

$namespaces:
  s: http://schema.org/
$schemas:
  - https://schema.org/docs/schema_org_rdfa.html

s:license: "https://mit-license.org/"
s:author:
  s:person.url: "http://orcid.org/0000-0002-6136-3724"
