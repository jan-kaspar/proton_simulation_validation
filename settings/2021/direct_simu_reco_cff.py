from Configuration.Eras.Era_Run3_cff import *
era = Run3

def LoadConfig(process):
  global config
  import Validation.CTPPS.simu_config.year_2021_cff as config
  process.load("Validation.CTPPS.simu_config.year_2021_cff")
