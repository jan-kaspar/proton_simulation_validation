import FWCore.ParameterSet.Config as cms

import sys
sys.path.append("../")

# load common code
import direct_simu_reco_cff as profile
process = cms.Process('CTPPSProtonReconstructionTest', profile.era)
profile.LoadConfig(process)

# minimal logger settings
process.MessageLogger = cms.Service("MessageLogger",
  statistics = cms.untracked.vstring(),
  destinations = cms.untracked.vstring('cout'),
  cout = cms.untracked.PSet(
    threshold = cms.untracked.string('WARNING')
  )
)

# number of events
process.maxEvents = cms.untracked.PSet(
  input = cms.untracked.int32(10)
)

# LHC info plots
process.ctppsLHCInfoPlotter = cms.EDAnalyzer("CTPPSLHCInfoPlotter",
  lhcInfoLabel = cms.string(""),
  outputFile = cms.string("")
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

  * process.ctppsLHCInfoPlotter
  * process.ctppsProtonReconstructionSimulationValidator
)

#----------

