from Configuration.Eras.Era_Run2_2018_cff import *
era = Run2_2018

def LoadConfig(process):
  global config
  import Validation.CTPPS.simu_config.year_2018_cff as config
  process.load("Validation.CTPPS.simu_config.year_2018_cff")
