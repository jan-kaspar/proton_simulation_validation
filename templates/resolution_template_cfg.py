import FWCore.ParameterSet.Config as cms

from Configuration.Eras.Modifier_ctpps_2016_cff import ctpps_2016
process = cms.Process('CTPPSProtonReconstructionTest', ctpps_2016)

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
  input = cms.untracked.int32(10)
)

# reconstruction validation
process.ctppsProtonReconstructionSimulationValidator = cms.EDAnalyzer("CTPPSProtonReconstructionSimulationValidator",
  tagHepMCBeforeSmearing = cms.InputTag("generator", "unsmeared"),
  tagHepMCAfterSmearing = cms.InputTag("beamDivergenceVtxGenerator"),
  tagRecoProtonsSingleRP = cms.InputTag("ctppsProtons", "singleRP"),
  tagRecoProtonsMultiRP = cms.InputTag("ctppsProtons", "multiRP"),

  lhcInfoLabel = cms.string(""),

  outputFile = cms.string("")
)

# processing path
process.p = cms.Path(
  process.generator
  * process.beamDivergenceVtxGenerator
  * process.ctppsDirectProtonSimulation

  * process.reco_local

  * process.ctppsProtons

  * process.ctppsProtonReconstructionSimulationValidator
)

#----------

