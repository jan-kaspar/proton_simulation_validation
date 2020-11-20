import FWCore.ParameterSet.Config as cms

# load common code
import direct_simu_reco_cff as profile
process = cms.Process('CTPPSTestLongExtrapolation', profile.era)
profile.LoadConfig(process)

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

# alternative optics mapping: simulate hits in far RPs with optics in near RPs + linear extrapolation
process.ctppsOpticalFunctionsESSourceTEST = process.ctppsOpticalFunctionsESSource.clone( label="TEST" )

scp = process.ctppsOpticalFunctionsESSourceTEST.configuration[0].scoringPlanes

scp[1].dirName = scp[0].dirName
scp[1].z = scp[0].z

scp[3].dirName = scp[2].dirName
scp[3].z = scp[2].z

for p in process.ctppsOpticalFunctionsESSourceTEST.configuration[0].scoringPlanes:
  print(p)


process.ctppsInterpolatedOpticalFunctionsESSourceTEST = process.ctppsInterpolatedOpticalFunctionsESSource.clone( opticsLabel="TEST" )

# alternative simulation
process.ctppsDirectProtonSimulationTEST = process.ctppsDirectProtonSimulation.clone( opticsLabel="TEST" )

process.RandomNumberGeneratorService.ctppsDirectProtonSimulationTEST = process.RandomNumberGeneratorService.ctppsDirectProtonSimulation.clone()

# alternative reconstruction
process.totemRPUVPatternFinderTEST = process.totemRPUVPatternFinder.clone( tagRecHit = cms.InputTag('ctppsDirectProtonSimulationTEST') )
process.totemRPLocalTrackFitterTEST = process.totemRPLocalTrackFitter.clone( tagUVPattern = cms.InputTag("totemRPUVPatternFinderTEST") )

process.ctppsPixelLocalTracksTEST = process.ctppsPixelLocalTracks.clone( label = "ctppsDirectProtonSimulationTEST" )

process.ctppsLocalTrackLiteProducerTEST = process.ctppsLocalTrackLiteProducer.clone(
  tagSiStripTrack = cms.InputTag("totemRPLocalTrackFitterTEST"),
  tagPixelTrack = cms.InputTag("ctppsPixelLocalTracksTEST"),
)

# difference plotter
process.ctppsDirectProtonSimulationValidator = cms.EDAnalyzer("CTPPSDirectProtonSimulationValidator",
  simuTracksTag = cms.InputTag("ctppsLocalTrackLiteProducer"),
  recoTracksTag = cms.InputTag("ctppsLocalTrackLiteProducerTEST"),
  outputFile = cms.string("test_long_extrapolation.root")
)

# processing path
process.p = cms.Path(
  process.generator
  * process.beamDivergenceVtxGenerator
  
  * process.ctppsDirectProtonSimulation
  * process.reco_local

  * process.ctppsDirectProtonSimulationTEST
  * process.totemRPUVPatternFinderTEST
  * process.totemRPLocalTrackFitterTEST
  * process.totemRPLocalTrackFitterTEST
  * process.ctppsPixelLocalTracksTEST
  * process.ctppsLocalTrackLiteProducerTEST

  * process.ctppsDirectProtonSimulationValidator
)
