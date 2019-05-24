import FWCore.ParameterSet.Config as cms

# beam parameters as declared by LHC
ctppsLHCInfoESSource = cms.ESSource("CTPPSLHCInfoESSource",
  label = cms.string(""),
  validityRange = cms.EventRange("0:min - 999999:max"),
  beamEnergy = cms.double(6500),  # GeV
  xangle = cms.double(-1)  # murad
)

# beam parameters as determined by PPS
ctppsBeamParametersESSource = cms.ESSource("CTPPSBeamParametersESSource",
  setBeamPars = cms.bool(True),

  #  beam momentum  (GeV)
  beamMom45 = cms.double(6500.),
  beamMom56 = cms.double(6500.),

  #  beta*  (cm)
  betaStarX45 = cms.double(0.),
  betaStarX56 = cms.double(0.),
  betaStarY45 = cms.double(0.),
  betaStarY56 = cms.double(0.),

  #  beam divergence  (rad)
  beamDivX45 = cms.double(30E-6),
  beamDivX56 = cms.double(30E-6),
  beamDivY45 = cms.double(30E-6),
  beamDivY56 = cms.double(30E-6),

  #  half crossing angle  (rad)
  halfXangleX45 = cms.double(-1),
  halfXangleX56 = cms.double(-1),
  halfXangleY45 = cms.double(0.),
  halfXangleY56 = cms.double(0.),

  #  vertex offset  (cm)
  vtxOffsetX45 = cms.double(0.),
  vtxOffsetX56 = cms.double(0.),
  vtxOffsetY45 = cms.double(0.),
  vtxOffsetY56 = cms.double(0.),
  vtxOffsetZ45 = cms.double(0.),
  vtxOffsetZ56 = cms.double(0.),

  #  vertex sigma  (cm)
  vtxStddevX = cms.double(10E-4),
  vtxStddevY = cms.double(10E-4),
  vtxStddevZ = cms.double(5)
)

# beam optics
from CalibPPS.ESProducers.ctppsOpticalFunctionsESSource_cfi import *

config_2018 = cms.PSet(
  validityRange = cms.EventRange("0:min - 999999:max"),

  opticalFunctions = cms.VPSet(
      cms.PSet( xangle = cms.double(120), fileName = cms.FileInPath("CalibPPS/ESProducers/data/optical_functions/2018/version3/120urad.root") ),
      cms.PSet( xangle = cms.double(130), fileName = cms.FileInPath("CalibPPS/ESProducers/data/optical_functions/2018/version3/130urad.root") ),
      cms.PSet( xangle = cms.double(140), fileName = cms.FileInPath("CalibPPS/ESProducers/data/optical_functions/2018/version3/140urad.root") )
  ),

  scoringPlanes = cms.VPSet(
      # z in cm
      cms.PSet( rpId = cms.uint32(2014838784), dirName = cms.string("XRPH_D6L5_B2"), z = cms.double(-21255.1) ),  # RP 003, pixel
      cms.PSet( rpId = cms.uint32(2023227392), dirName = cms.string("XRPH_B6L5_B2"), z = cms.double(-21955.0) ),  # RP 023, pixel
      cms.PSet( rpId = cms.uint32(2031616000), dirName = cms.string("XRPH_D6R5_B1"), z = cms.double(+21255.1) ),  # RP 103, pixel
      cms.PSet( rpId = cms.uint32(2040004608), dirName = cms.string("XRPH_B6R5_B1"), z = cms.double(+21955.0) ),  # RP 123, pixel
  )
)

ctppsOpticalFunctionsESSource.configuration.append(config_2018)

# geometry
from Geometry.VeryForwardGeometry.geometryRPFromDD_2018_cfi import *
del(XMLIdealGeometryESSource_CTPPS.geomXMLFiles[-1])
XMLIdealGeometryESSource_CTPPS.geomXMLFiles.append("$CWD/RP_Dist_Beam_Cent.xml")

# particle-data table
from SimGeneral.HepPDTESSource.pythiapdt_cfi import *

# random seeds
RandomNumberGeneratorService = cms.Service("RandomNumberGeneratorService",
    sourceSeed = cms.PSet(initialSeed =cms.untracked.uint32(98765)),
    generator = cms.PSet(initialSeed = cms.untracked.uint32(98766)),
    beamDivergenceVtxGenerator = cms.PSet(initialSeed =cms.untracked.uint32(3849))
)

# default source
source = cms.Source("EmptySource",
    firstRun = cms.untracked.uint32(1)
)

# particle generator
from Validation.CTPPS.randomXiThetaGunProducer_cfi import *

# beam smearing
from IOMC.EventVertexGenerators.beamDivergenceVtxGenerator_cfi import *

# direct simulation
from Validation.CTPPS.ctppsDirectProtonSimulation_cfi import *
ctppsDirectProtonSimulation.verbosity = 0
ctppsDirectProtonSimulation.hepMCTag = cms.InputTag('beamDivergenceVtxGenerator')
ctppsDirectProtonSimulation.useEmpiricalApertures = True
ctppsDirectProtonSimulation.roundToPitch = True
ctppsDirectProtonSimulation.pitchStrips = 66E-3 * 12 / 19 # effective value to reproduce real RP resolution
ctppsDirectProtonSimulation.pitchPixelsHor = 60E-3
ctppsDirectProtonSimulation.pitchPixelsVer = 80E-3
ctppsDirectProtonSimulation.produceHitsRelativeToBeam = True
ctppsDirectProtonSimulation.produceScoringPlaneHits = False
ctppsDirectProtonSimulation.produceRecHits = True

# local reconstruction
from RecoCTPPS.TotemRPLocal.totemRPLocalReconstruction_cff import *
from RecoCTPPS.PixelLocal.ctppsPixelLocalReconstruction_cff import *
from RecoCTPPS.TotemRPLocal.ctppsLocalTrackLiteProducer_cff import *

totemRPUVPatternFinder.tagRecHit = cms.InputTag('ctppsDirectProtonSimulation')

ctppsPixelLocalTracks.label = "ctppsDirectProtonSimulation"

ctppsLocalTrackLiteProducer.includeDiamonds = False

reco_local = cms.Sequence(
  totemRPUVPatternFinder
  * totemRPLocalTrackFitter
  * ctppsPixelLocalTracks
  * ctppsLocalTrackLiteProducer
)

# proton reconstruction
from RecoCTPPS.ProtonReconstruction.ctppsProtons_cff import *
ctppsProtons.tagLocalTrackLite = cms.InputTag('ctppsLocalTrackLiteProducer')

# RP ids
rpIds = cms.PSet(
  rp_45_F = cms.uint32(23),
  rp_45_N = cms.uint32(3),
  rp_56_N = cms.uint32(103),
  rp_56_F = cms.uint32(123)
)
