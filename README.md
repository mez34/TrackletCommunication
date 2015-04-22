# TrackletCommunication
# TrackletCommunication

# Getting Started
Project File is located at project_1/project_1.xpr
If you open this in Vivado (I have been using version 2014.3, but it seemed to work also in 2014.4)
it should load the project with the file heirarchy. 

# Heirarchy
## mem_readout_tb1.v
This is a test bench (that loads in testdata files into 12 memories) and runs the unit under test (uut) 
which is the ProjTransceiver.v module. 

## ProjTransceiver.v
Essentially, the top layer of the code. This module matches Jorge's interface and is in the process of being 
integrated into his code. The output of ProjTransceiver is 12 streams of data (i.e. output_L1L2_1) that 
would then be sent to their respective memories. It calls:

### mem_readout_top.v
This starts the priority encoder. The main output is a single data stream (mem_dat_stream) with a corresponding valid
signal. The details of the priority encoder are in Charlie's email. 

## fifo_projection_out.v
Send the mem_dat_stream to a FIFO.
FIFO is generated with the IP Catalog (in top left under "Project Manager"). You will likely have to reinitialize (right click on FIFO and hit "Generate Output Products". You can change the FIFO settings (ex. word length by "Recustomizing"). 
I now have 2 FIFOs in the code i.e. one for sending out one for coming back in, although mine are just hooked up right to
each other, the Aurora protocol and link would go between these two. 

## mem_readin_top.v
Take output of 2nd FIFO and redistribute the data (now residuals) to 12 data streams that will be sent to 12 memories. 

#Simulation
You should be able to run all of this in Simulation, by going to Simulation, and "Run Simulation" and then "Behavioral Simulation". Can look at output wave config (.wcfg) to see the values of each object at all times. 








