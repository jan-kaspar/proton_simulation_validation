from Configuration.Eras.Era_Run2_2016_cff import *
era = Run2_2016

def LoadConfig(process):
  global config
  import Validation.CTPPS.simu_config.year_2016_preTS2_cff as config
  process.load("Validation.CTPPS.simu_config.year_2016_preTS2_cff")
