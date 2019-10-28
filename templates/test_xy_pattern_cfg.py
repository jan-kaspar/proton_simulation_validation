import FWCore.ParameterSet.Config as cms

# load common code
from direct_simu_reco_cff import *
process = cms.Process('CTPPSFastSimulation', era)
process.load("direct_simu_reco_cff")
SetDefaults(process)

# set wide angle coverage
process.generator.theta_x_sigma = 200E-6
process.generator.theta_y_sigma = 200E-6

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
  input = cms.untracked.int32(10000)
)

# distribution plotter
process.ctppsTrackDistributionPlotter = cms.EDAnalyzer("CTPPSTrackDistributionPlotter",
  tagTracks = cms.InputTag("ctppsLocalTrackLiteProducer"),
  outputFile = cms.string("test_xy_pattern.root")
)

# processing path
process.p = cms.Path(
  process.generator
  * process.beamDivergenceVtxGenerator
  * process.ctppsDirectProtonSimulation

  * process.reco_local
  
  * process.ctppsTrackDistributionPlotter
)
