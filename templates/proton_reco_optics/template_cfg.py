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

# define (biased) optics for reconstruction
process.ctppsModifiedOpticalFunctionsESSource = cms.ESProducer("CTPPSModifiedOpticalFunctionsESSource",
  inputOpticsLabel = cms.string(""),
  outputOpticsLabel = cms.string("modified"),

  scenario = cms.string("$scenario"),
  factor = cms.double($factor),

  rpId_45_F = process.rpIds.rp_45_F,
  rpId_45_N = process.rpIds.rp_45_N,
  rpId_56_N = process.rpIds.rp_56_N,
  rpId_56_F = process.rpIds.rp_56_F,
)

# optics plotters
#process.ctppsOpticsPlotter_def = cms.EDAnalyzer("CTPPSOpticsPlotter",
#  opticsLabel = cms.string(""),
#  outputFile = cms.string("optics_default.root")
#)

process.ctppsOpticsPlotter_mod = cms.EDAnalyzer("CTPPSOpticsPlotter",
  opticsLabel = cms.string("modified"),

  rpId_45_F = process.rpIds.rp_45_F,
  rpId_45_N = process.rpIds.rp_45_N,
  rpId_56_N = process.rpIds.rp_56_N,
  rpId_56_F = process.rpIds.rp_56_F,

  outputFile = cms.string("optics_modified.root")
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

# update reconstruction to use the modified optics
process.ctppsProtons.opticsLabel = "modified"

# processing path
process.p = cms.Path(
  process.generator
  * process.beamDivergenceVtxGenerator
  * process.ctppsDirectProtonSimulation

  * process.reco_local

  * process.ctppsProtons

  #* process.ctppsOpticsPlotter_def
  * process.ctppsOpticsPlotter_mod

  * process.ctppsProtonReconstructionSimulationValidator
)

#----------

profile.config.SetLargeTheta(process)
profile.config.SetLevel4(process)

