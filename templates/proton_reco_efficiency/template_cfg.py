import FWCore.ParameterSet.Config as cms

import sys
sys.path.append("../../../")

# load common code
from customisation_cff import *
process = cms.Process('CTPPSProtonReconstructionTest', era)
process.load("direct_simu_reco_cff")
SetDefaults(process)

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

# reconstruction efficiency 
process.ctppsProtonReconstructionEfficiencyEstimator = cms.EDAnalyzer("CTPPSProtonReconstructionEfficiencyEstimator",
  tagHepMCAfterSmearing = cms.InputTag("beamDivergenceVtxGenerator"),
  tagStripRecHitsPerParticle = cms.InputTag('ctppsDirectProtonSimulation'),
  tagPixelRecHitsPerParticle = cms.InputTag('ctppsDirectProtonSimulation'),
  tagTracks = cms.InputTag('ctppsLocalTrackLiteProducer'),
  tagRecoProtonsMultiRP = cms.InputTag("ctppsProtons", "multiRP"),

  lhcInfoLabel = cms.string(""),

  rpId_45_F = process.rpIds.rp_45_F,
  rpId_45_N = process.rpIds.rp_45_N,
  rpId_56_N = process.rpIds.rp_56_N,
  rpId_56_F = process.rpIds.rp_56_F,

  outputFile = cms.string("reco_efficiency.root")
)

# processing path
process.p = cms.Path(
    process.generator
    * process.beamDivergenceVtxGenerator
    * process.ctppsDirectProtonSimulation

    * process.reco_local

    * process.ctppsProtons

    * process.ctppsProtonReconstructionEfficiencyEstimator
)

#----------

def AssociationNoCut():
  process.ctppsProtons.association_cuts_45.x_cut_apply = False
  process.ctppsProtons.association_cuts_45.y_cut_apply = False
  process.ctppsProtons.association_cuts_45.xi_cut_apply = False
  process.ctppsProtons.association_cuts_45.th_y_cut_apply = False

  process.ctppsProtons.association_cuts_56.x_cut_apply = False
  process.ctppsProtons.association_cuts_56.y_cut_apply = False
  process.ctppsProtons.association_cuts_56.xi_cut_apply = False
  process.ctppsProtons.association_cuts_56.th_y_cut_apply = False

def AssociationXi(xi):
  AssociationNoCut()

  process.ctppsProtons.association_cuts_45.xi_cut_apply = True
  process.ctppsProtons.association_cuts_45.xi_cut_value = xi

  process.ctppsProtons.association_cuts_56.xi_cut_apply = True
  process.ctppsProtons.association_cuts_56.xi_cut_value = xi

def AssociationXiThy(xi, thy):
  AssociationNoCut()

  process.ctppsProtons.association_cuts_45.xi_cut_apply = True
  process.ctppsProtons.association_cuts_45.xi_cut_value = xi
  process.ctppsProtons.association_cuts_45.th_y_cut_apply = True
  process.ctppsProtons.association_cuts_45.th_y_cut_value = thy

  process.ctppsProtons.association_cuts_56.xi_cut_apply = True
  process.ctppsProtons.association_cuts_56.xi_cut_value = xi
  process.ctppsProtons.association_cuts_56.th_y_cut_apply = True
  process.ctppsProtons.association_cuts_56.th_y_cut_value = thy

#----------

