#/bin/bash

nvidia-settings --assign="GPUOverclockingState=1"
nvidia-settings --assign="GPU2DClockFreqs=120,150"
nvidia-settings --assign="GPU3DClockFreqs=500,720"
nvidia-settings --assign="SyncToVBlank=0"
nvidia-settings --assign="DigitalVibrance=256"
nvidia-settings --assign="FSAA=5"
nvidia-settings --assign="[DPY:DVI-I-0]/RedGamma=0.970000"
nvidia-settings --assign="[DPY:DVI-I-0]/GreenGamma=0.970000"
nvidia-settings --assign="[DPY:DVI-I-0]/BlueGamma=0.970000"

