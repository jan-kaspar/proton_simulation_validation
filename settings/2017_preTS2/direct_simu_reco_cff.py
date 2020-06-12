from Configuration.Eras.Era_Run2_2017_cff import *
era = Run2_2017

def LoadConfig(process):
  global config
  import Validation.CTPPS.simu_config.year_2017_preTS2_cff as config
  process.load("Validation.CTPPS.simu_config.year_2017_preTS2_cff")
