<?php
ini_set("pcre.jit", "0");
$handle = fopen("input.txt", "r");
$stage = 0;
$rules = array();

function getRegex($_entry): string {
  global $rules;
  $entry = explode(" ", $rules[$_entry]);

  if ($_entry == "8") {
    return "(" . getRegex($entry[0]) . "|" . getRegex($entry[2]) . "(?&r8))";
  } elseif ($_entry == "11") {
    return "(" . getRegex($entry[0]) . getRegex($entry[1]) . "|" . getRegex($entry[3]) . "(?&r11)" . getRegex($entry[5]) . ")";
  }

  if (count($entry) == 1) {
    if (preg_match("/\"[ab]\"/", $entry[0]))
      return str_replace('"', '', $entry[0]);
    return getRegex($entry[0]);
  } elseif (count($entry) == 2) {
    return "(" . getRegex($entry[0]) . getRegex($entry[1]) . ")";
  } elseif (count($entry) == 3) {
    return "(" . getRegex($entry[0]) . "|" . getRegex($entry[2]) . ")";
  } elseif (count($entry) == 5) {
    return "(" . getRegex($entry[0]) . getRegex($entry[1]) . "|" . getRegex($entry[3]) . getRegex($entry[4]) . ")";
  }
  return "";
}

$regex = "";
$count = 0;
while (($line = trim(fgets($handle))) !== false) {
  if (!$line) {
    $stage++;
    if ($stage == 1) {
      $rules["8"] = "42 | 42 8";
      $rules["11"] = "42 31 | 42 11 31";
      $regex = "(?(DEFINE) (?<r8>" . getRegex("8") . ") (?<r11>" . getRegex("11") . "))" . getRegex("0");
    } else break;
    continue;
  }
  if ($stage == 0) {
    $line = explode(": ", $line);
    $rules[$line[0]] = $line[1];
  } else {
    $count += preg_match("/^$regex$/", $line);
  }
}
printf($count);