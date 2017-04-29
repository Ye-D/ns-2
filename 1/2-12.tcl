proc dumb_proc {} {
set local_var 4
puts "the local var is $local_var"
global myglobalvar
puts "the global var is $myglobalvar"
}
set myglobalvar 79
dumb_proc
