import FWCore.ParameterSet.Config as cms

# load common code
import direct_simu_reco_cff as profile
process = cms.Process('CTPPSTestSmearingEffects', profile.era)
profile.LoadConfig(process)
profile.config.SetDefaults(process)

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
  input = cms.untracked.int32(10000)
)

# direct simulation with and without smearing
process.ctppsDirectProtonSimulation.produceScoringPlaneHits = True

process.ctppsDirectProtonSimulationNoSm = process.ctppsDirectProtonSimulation.clone(
  hepMCTag = cms.InputTag("generator", "unsmeared"),
  produceScoringPlaneHits = True,
  produceRecHits = False,
)

process.RandomNumberGeneratorService.ctppsDirectProtonSimulationNoSm = process.RandomNumberGeneratorService.ctppsDirectProtonSimulation.clone()

# plotters
process.ctppsDirectProtonSimulationValidatorBeamSm = cms.EDAnalyzer("CTPPSDirectProtonSimulationValidator",
  simuTracksTag = cms.InputTag("ctppsDirectProtonSimulationNoSm"),
  recoTracksTag = cms.InputTag("ctppsDirectProtonSimulation"),
  outputFile = cms.string("test_smearing_effects_beam.root")
)

process.ctppsDirectProtonSimulationValidatorSensorSm = cms.EDAnalyzer("CTPPSDirectProtonSimulationValidator",
  simuTracksTag = cms.InputTag("ctppsDirectProtonSimulation"),
  recoTracksTag = cms.InputTag("ctppsLocalTrackLiteProducer"),
  outputFile = cms.string("test_smearing_effects_sensor.root")
)

# processing path
process.p = cms.Path(
  process.generator
  * process.beamDivergenceVtxGenerator
  * process.ctppsDirectProtonSimulationNoSm
  * process.ctppsDirectProtonSimulation

  * process.reco_local

  * process.ctppsDirectProtonSimulationValidatorBeamSm
  * process.ctppsDirectProtonSimulationValidatorSensorSm
)
