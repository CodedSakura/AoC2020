$field_map = {}
$valid = 0

def reset_field_map
  $field_map = {
    byr: false,
    iyr: false,
    eyr: false,
    hgt: false,
    hcl: false,
    ecl: false,
    pid: false,
    cid: false
  }
end

def check_field_map
  still_valid = true
  $field_map.each do |key, value|
    still_valid &= value if key != :cid
  end
  $valid += 1 if still_valid
end

reset_field_map

File.open("input.txt") do |f|
  f.each_line do |line|
    if line !~ /\S/
      check_field_map
      reset_field_map
    else
      line.split(" ") do |word|
        $field_map.keys.each do |key|
          $field_map[key] = true if word.start_with?(key.to_s)
        end
      end
    end
  end
  check_field_map
end

puts $valid
