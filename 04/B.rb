$field_map = {}
$valid = 0

def reset_field_map
  $field_map = {
    byr: nil, # 1920 - 2002
    iyr: nil, # 2010 - 2020
    eyr: nil, # 2020 - 2030
    hgt: nil, # 150cm - 193cm | 56in - 76in
    hcl: nil, # #[0-9a-f]{6}
    ecl: nil, # amb|blu|brn|gry|grn|hzl|oth
    pid: nil, # \d{9}
    cid: nil
  }
end

def check_field_map
  still_valid = true
  $field_map.each do |key, value|
    val = value != nil &&
      case key
      when :byr; value.to_i.between?(1920, 2002)
      when :iyr; value.to_i.between?(2010, 2020)
      when :eyr; value.to_i.between?(2020, 2030)
      when :hgt; value.end_with?("cm") ? value[0..-3].to_i.between?(150, 193) : value[0..-3].to_i.between?(56, 76)
      when :hcl; value.match(/^#[0-9a-f]{6}$/)
      when :ecl; value.match(/^amb|blu|brn|gry|grn|hzl|oth$/)
      when :pid; value.match(/^\d{9}$/)
      else true
      end
    still_valid &= val if key != :cid
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
          $field_map[key] = word[4..-1] if word.start_with?(key.to_s)
        end
      end
    end
  end
  check_field_map
end

puts $valid
