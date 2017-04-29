set person_info(name) "ferd"
set person_info(age) "25"
set person_info(occupation) "teacher"

foreach thing {name age occupation} {
puts "$thing is $person_info($thing)"
}
