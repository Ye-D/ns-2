set val(chan)	Channel/WirelessChannel
set val(prop)	Propagation/TwoRayGround
set val(netif)	Phy/WirelessPhy
set val(mac)	Mac/802_11
set val(ifq)	Queue/DropTail/PriQueue
set val(ll)	LL
set val(ant)	Antenna/OmniAntenna
set val(ifqlen)	50
set val(rp)	DSDV

set ns [new Simulator]

Mac/802_11 set RTSThreshold_	3000

set f [open test.tr w]
$ns trace-all $f
$ns eventtrace-all
set nf [open test.nam w]
$ns namtrace-all-wireless $nf 500 500

set topo [new Topography]
$topo load_flatgrid 500 500

create-god 3

set chan [new $val(chan)]

$ns node-config -adhocRouting $val(rp)\
		-llType $val(ll)\
		-macType $val(mac)\
		-ifqType $val(ifq)\
		-ifqLen $val(ifqlen)\
		-antType $val(ant)\
		-propType $val(prop)\
		-phyType $val(netif)\
		-channel $chan\
		-topoInstance $topo\
		-agentTrace ON\
		-routerTrace OFF\
		-macTrace ON\
		-movementTrace OFF

set node_(0) [$ns node]
$node_(0) random-motion 0
$node_(0) set X_ 100
$node_(0) set Y_ 100

set 11m_node_(0) [$ns node]
set rng [new RNG]
$rng seed 1
set RVdistance [new RandomVariable/Uniform]
$RVdistance set min_ 1
$RVdistance set max_ 10
$RVdistance use-rng $rng
$11m_node_(0) random-motion 0
$11m_node_(0) set X_ [expr 100+[$RVdistance value]]
$11m_node_(0) set Y_ [expr 100+[$RVdistance value]]
$11m_node_(0) set Z_ 0.0

set 11m_mac_n(0) [$11m_node_(0) set mac_(0)]
$11m_mac_n(0) set dataRate_ 11Mb
$11m_mac_n(0) set basicRate_ 1Mb

set 11m_udp [new Agent/mUDP]
$11m_udp set_filename 11m_sd
$ns attach-agent $11m_node_(0) $11m_udp
set null [new Agent/mUdpSink]
$null set_filename 11m_rd
$ns attach_agent $node_(0) $null
$ns connect $11m_udp $null

set 11m_cbr_(0) [new Application/Traffic/CBR]
$11m_cbr_(0) attach-agent $11m_udp
$11m_cbr_(0) set type_ CBR
$11m_cbr_(0) set packet_size_ 1000
$11m_cbr_(0) set rate_ 2Mb
$11m_cbr_(0) set random_ false
$ns at 1.0 "$11m_cbr_(0) start"
$ns at 45.0 "$11m_cbr_(0) stop"

set 1m_node_(0) [$ns node]
$1m_node_(0) random-motion 0
set rng [new RNG]
$rng seed 2
set RVdistance [new RandomVariable/Uniform]
$RVdistance set min_ 10
$RVdistance set max_ 25
$RVdistance use-rng $rng
$1m_node_(0) set X_ [expr 100+[$RVdistance]]
$1m_node_(0) set Y_ [expr 100+[$RVdistance]]
$1m_node_(0) set Z_ 0.0

set 1m_mac_n(0) [$1m_node_(0) set mac_(0)]
$1m_mac_n(0) set dataRate_ 11Mb
$1m_mac_n(0) set basicRate_ 1Mb

$ns at 15.0 "$1m_mac_n(0) set dataRate_ 1Mb"
set 1m_udp [new Agent/mUDP]
$1m_udp_set_filename 1m_sd
$ns attach-agent $1m_node_(0) $1m_udp
set null2 [new Agent/mUdpSink]
$null2 set_filename 1m_rd
$ns attach-agent $node_(0) $null2
$ns connect $1m_udp $null2

set 1m_cbr_(0) [new Application/Traffic/CBR]
$1m_cbr_(0) attach-agent $1m_udp
$1m_cbr_(0) set type_ CBR
$1m_cbr_(0) set packet_size_ 1000
$1m_cbr_(0) set rate_ 2Mb
$1m_cbr_(0) set random_false
$ns at 1.0 "$1m_cbr_(0) start"
$ns at 30.0 "$1m_cbr_(0) stop"

$ns at 50.0 "finish"
$ns at 50.1 "puts\"NS EXITING...\";$ns halt"

proc finish {} {
	global ns f nf val
	$ns flush-trace
	close $f
	close $nf
}

puts "Starting Simulation..."
$ns run
