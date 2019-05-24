import FWCore.ParameterSet.Config as cms

def SetLevel1(process):
  process.ctppsBeamParametersESSource.vtxStddevX = 0E-4
  process.ctppsBeamParametersESSource.vtxStddevZ = 0

  process.ctppsBeamParametersESSource.beamDivX45 = 0E-6
  process.ctppsBeamParametersESSource.beamDivX56 = 0E-6
  process.ctppsBeamParametersESSource.beamDivY45 = 0E-6
  process.ctppsBeamParametersESSource.beamDivY56 = 0E-6

  process.ctppsDirectProtonSimulation.roundToPitch = False


def SetLevel2(process):
  process.ctppsBeamParametersESSource.beamDivX45 = 0E-6
  process.ctppsBeamParametersESSource.beamDivX56 = 0E-6
  process.ctppsBeamParametersESSource.beamDivY45 = 0E-6
  process.ctppsBeamParametersESSource.beamDivY56 = 0E-6

  process.ctppsDirectProtonSimulation.roundToPitch = False


def SetLevel3(process):
  process.ctppsDirectProtonSimulation.roundToPitch = False


def SetLevel4(process):
  pass


def SetLowTheta(process):
  process.generator.theta_x_sigma = 0E-6
  process.generator.theta_y_sigma = 0E-6


def SetLargeTheta(process):
  pass


# xangle in murad
def UseCrossingAngle(xangle, process):
  process.ctppsLHCInfoESSource.xangle = xangle
  process.ctppsBeamParametersESSource.halfXangleX45 = xangle * 1E-6
  process.ctppsBeamParametersESSource.halfXangleX56 = xangle * 1E-6

  process.ctppsDirectProtonSimulation.empiricalAperture45_xi0 = 0.066 + 3.54E-4 * xangle
  process.ctppsDirectProtonSimulation.empiricalAperture45_a = -( -56 - 0.38 * xangle )
  process.ctppsDirectProtonSimulation.empiricalAperture56_xi0 = 0.062 + 5.96E-4 * xangle
  process.ctppsDirectProtonSimulation.empiricalAperture56_a = -( +39 - 1.36 * xangle )


def SetDefaults(process):
  UseCrossingAngle(150, process)
