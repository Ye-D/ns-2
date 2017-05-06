#模板

#产生一个仿真对象
set ns [new Simulator]

#定义一个结束程序
proc finish {} {
	exit 0
}

#增加网络结构和应用开发的程序代码


#在适当的时间调用finish，结束仿真
$ns at 5.0 "finish"

#开始仿真
$ns run
