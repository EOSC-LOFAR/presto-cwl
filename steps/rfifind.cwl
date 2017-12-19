cwlVersion: v1.0
class: CommandLineTool
baseCommand: rfifind
doc: >
  Examines radio data for narrow and wide band interference as well as
  problems with channels

hints:
  DockerRequirement:
      dockerImageId: kernsuite/presto

inputs:
  filterbank:
    type: File
    inputBinding:
      position: 1

  time:
    type: float?
    inputBinding:
      prefix: -time

  noclip:
    type: boolean?
    inputBinding:
      prefix: -noclip

  nocompute:
    type: boolean?
    inputBinding:
      prefix: -nocompute

arguments:
  - prefix: -o
    valueFrom: $(inputs.filterbank.nameroot)

outputs:
  bytemask:
    type: File
    outputBinding:
      glob: $(inputs.filterbank.nameroot)_rfifind.bytemask

  inf:
    type: File
    outputBinding:
      glob: $(inputs.filterbank.nameroot)_rfifind.inf

  mask:
    type: File
    outputBinding:
      glob: $(inputs.filterbank.nameroot)_rfifind.mask

  ps:
    type: File
    outputBinding:
      glob: $(inputs.filterbank.nameroot)_rfifind.ps

  rfi:
    type: File
    outputBinding:
      glob: $(inputs.filterbank.nameroot)_rfifind.rfi

  stats:
    type: File
    outputBinding:
      glob: $(inputs.filterbank.nameroot)_rfifind.stats

$namespaces:
  s: http://schema.org/
$schemas:
  - https://schema.org/docs/schema_org_rdfa.html

s:license: "https://mit-license.org/"
s:author:
  s:person.url: "http://orcid.org/0000-0002-6136-3724"
