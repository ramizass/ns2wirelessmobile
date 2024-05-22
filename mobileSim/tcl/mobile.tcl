# Define Options
set val(chan)      Channel/WirelessChannel  ;# Channel Type
set val(prop)      Propagation/TwoRayGround ;# Radio Propagation Model
set val(netif)     Phy/WirelessPhy          ;# Network Interface Type
set val(mac)       Mac/802_11               ;# MAC Type (note the corrected case: Mac instead of MAC)
set val(ifq)       Queue/DropTail/PriQueue  ;# Interface Queue Type
set val(ll)        LL                       ;# Link Layer Type
set val(ant)       Antenna/OmniAntenna      ;# Antenna Model
set val(ifqlen)    50                       ;# Max Packet in ifq
set val(n)         4                        ;# Number of Mobile Nodes
set val(rp)        DSDV                     ;# Routing Protocol
set val(x)         500
set val(y)         500

# Create Simulator
set ns_ [new Simulator]

# Create Trace Object
set traceout1 [open mobile.tr w]
$ns_ trace-all $traceout1

# Create a NAM Trace File
set namout1 [open mobile.nam w]
$ns_ namtrace-all-wireless $namout1 $val(x) $val(y)

# Create Object Topology
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

# Create GOD for saving all configuration
create-god $val(n)

# Create Channel #1
set chan_1_ [new $val(chan)]

# Create node-config
$ns_ node-config -adhocRouting $val(rp) \
                 -llType $val(ll) \
                 -macType $val(mac) \
                 -ifqType $val(ifq) \
                 -ifqLen $val(ifqlen) \
                 -phyType $val(netif) \
                 -antType $val(ant) \
                 -propType $val(prop) \
                 -topoInstance $topo \
                 -agentTrace ON \
                 -routerTrace ON \
                 -macTrace ON \
                 -movementTrace OFF \
                 -channel $chan_1_

# Create Nodes
for {set i 0} {$i < $val(n)} {incr i} {
    set node_($i) [$ns_ node]
}
$node_(0) random-motion 0
$node_(1) random-motion 0

#Node Initial Position Topology
$node_(0) set X_ 5.0
$node_(0) set Y_ 2.0
$node_(0) set Z_ 0.0
$node_(1) set X_ 390.0
$node_(1) set Y_ 385.0

#Define Node Size in NAM editor
for {set i 0} {$i < $val(n)} {incr i} {
	$ns_ initial_node_pos $node_($i) 30
}

$ns_ at 2.0 "$node_(1) setdest 100.0 40.0 25.0"
$ns_ at 3.0 "$node_(0) setdest 300.0 400.0 40.0"
$ns_ at 10.0 "$node_(1) setdest 490.0 480.0 40.0"

#Create a TCP Flow from n0 to n1
set tcp [new Agent/TCP]
$tcp set class_ 2
set sink [new Agent/TCPSink]
$ns_ attach-agent $node_(0) $tcp
$ns_ attach-agent $node_(1) $sink
$ns_ connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns_ at 4.0 "$ftp start"

#End Simulation
for {set i 0} {$i < $val(n)} {incr i} {
	$ns_ at 20.0 "$node_($i) reset"
}
$ns_ at 20.001 "stop"
$ns_ at 20.002 "puts \"NS EXITING...\" ; $ns_ halt"

#Define a finish procedure
proc stop {} {
	global ns_ traceout1 namout1
	$ns_ flush-trace
	close $traceout1
	close $namout1
	exec nam mobile.nam &
	exit 0
}
puts "Starting Simulation....."
$ns_ run
