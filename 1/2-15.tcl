set person_info(name) "ferd"
set person_info(age) "25"
set person_info(occupation) "teacher"

foreach thing [array names person_info] {
puts "$thing is $person_info($thing)"
}
#array names person_info lie ju chu le suo you de yuan su 
