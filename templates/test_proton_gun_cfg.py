import FWCore.ParameterSet.Config as cms

# load common code
from customisation_cff import *
process = cms.Process('CTPPSFastSimulation', era)
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

# plotter
process.ctppsHepMCDistributionPlotter = cms.EDAnalyzer("CTPPSHepMCDistributionPlotter",
  tagHepMC = cms.InputTag("generator", "unsmeared"),
  lhcInfoLabel = cms.string(""),
  outputFile = cms.string("test_proton_gun.root")
)

# processing path
process.p = cms.Path(
  process.generator
  * process.ctppsHepMCDistributionPlotter
)
