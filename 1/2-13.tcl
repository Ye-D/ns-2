set myarray(0) "ZERO"
set myarray(1) "ONE"
set myarray(2) "TWO"

for {set i 0} {$i<3} {incr i} {
puts $myarray($i)
}
