import FWCore.ParameterSet.Config as cms

from Configuration.Eras.Modifier_ctpps_2016_cff import ctpps_2016
process = cms.Process('CTPPSTestBeamSmearing', ctpps_2016)

# load common code
process.load("direct_simu_reco_cff")
from customisation_cff import *
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
