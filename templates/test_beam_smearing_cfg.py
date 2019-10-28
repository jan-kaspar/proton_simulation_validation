import FWCore.ParameterSet.Config as cms

# load common code
from direct_simu_reco_cff import *
process = cms.Process('CTPPSTestBeamSmearing', era)
process.load("direct_simu_reco_cff")
SetDefaults(process)

# minimal logger settings
process.MessageLogger = cms.Service("MessageLogger",
  statistics = cms.untracked.vstring(),
  destinations = cms.untracked.vstring('cerr'),
  cerr = cms.untracked.PSet(
    threshold = cms.untracked.string('WARNING')
  )
)

# number of events
process.maxEvents = cms.untracked.PSet(
  input = cms.untracked.int32(40000)
)

# beam-smearing validation
process.ctppsBeamSmearingValidator = cms.EDAnalyzer("CTPPSBeamSmearingValidator",
  tagBeforeSmearing = cms.InputTag("generator", "unsmeared"),
  tagAfterSmearing = cms.InputTag("beamDivergenceVtxGenerator"),
  outputFile = cms.string("test_beam_smearing.root")
)

# processing path
process.p = cms.Path(
  process.generator
  * process.beamDivergenceVtxGenerator
  * process.ctppsBeamSmearingValidator
)
