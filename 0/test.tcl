#建立一个模拟

set ns [new Simulator]



#定义不同数据流的颜色（NAM显示时用到）

$ns color 1 Blue

$ns color 2 Red



#开启Trace跟踪和NAM跟踪

set tracefd [open wired.tr w]

$ns trace-all $tracefd

set nf [open wired.nam w]

$ns namtrace-all $nf



#定义结束进程

proc finish {} {

	global ns tracefd nf

	$ns flush-trace

	close $tracefd

	close $nf

	exit 0

}



#定义节点

set n0 [$ns node]

set n1 [$ns node]

set n2 [$ns node]

set n3 [$ns node]

set n4 [$ns node]

set n5 [$ns node]

#$n5 color black

$n5 color red



#定义节点间的链路

$ns duplex-link $n0 $n1 2Mb 10ms DropTail

$ns duplex-link $n1 $n2 2Mb 10ms DropTail

$ns duplex-link $n1 $n4 2Mb 20ms DropTail

$ns duplex-link $n3 $n4 2Mb 10ms DropTail

$ns duplex-link $n4 $n5 2Mb 10ms DropTail



#定义链路的队列长度

$ns queue-limit $n1 $n4 10



#指定节点间的相互位置（NAM显示用到）

$ns duplex-link-op $n0 $n1 orient right-down

$ns duplex-link-op $n2 $n1 orient right-up

$ns duplex-link-op $n1 $n4 orient right

$ns duplex-link-op $n3 $n4 orient left-down

$ns duplex-link-op $n5 $n4 orient left-up



#监视链路的队列

$ns duplex-link-op $n1 $n4 queuePos 0.5



#建立一个TCP连接

set tcp [new Agent/TCP] 

$tcp set class_ 2

$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]

$ns attach-agent $n5 $sink

$ns connect $tcp $sink

$tcp set fid_ 1



#在TCP连接上建立FTP流

set ftp [new Application/FTP]

$ftp attach-agent $tcp

$ftp set type_ FTP



#建立一个UDP代理

set udp [new Agent/UDP]             ;#建立一个数据发送代理

$ns attach-agent $n2 $udp           ;#将数据发送代理绑定到发送节点

set null [new Agent/Null]           ;#建立一个数据接收代理

$ns attach-agent $n3 $null          ;#将数据接收代理绑定到接收节点

$ns connect $udp $null              ;#连接两个代理（也就决定了数据包的发送和接收节点）

$udp set fid_ 2



#在UDP代理上建立CBR流

set cbr [new Application/Traffic/CBR]

$cbr attach-agent $udp

$cbr set type_ CBR

$cbr set packet_size_ 1000

$cbr set rate_ 1mb

$cbr set random_ false



#启动和结束流代理

$ns at 0.5 "$cbr start"

$ns at 1.0 "$ftp start"

$ns at 9.0 "$ftp stop"

$ns at 9.5 "$cbr stop"



$ns at 9.5 "$ns detach-agent $n0 $tcp; $ns detach-agent $n5 $sink"



#仿真结束时调用结束进程

$ns at 10.0 "finish"



#打印CBR数据包的大小和间隔

puts "CBR packet_size_ = [$cbr set packet_size_]"

puts "CBR interval = [$cbr set interval_]"



#执行模拟

$ns run
