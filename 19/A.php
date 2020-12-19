<?php
$handle = fopen("input.txt", "r");
$stage = 0;
$rules = array();

function getRegex($entry): string {
  global $rules;
  $entry = explode(" ", $rules[$entry]);
  if (count($entry) == 1) {
    if (preg_match("/\"[ab]\"/", $entry[0]))
      return str_replace('"', '', $entry[0]);
    return getRegex($entry[0]);
  } else if (count($entry) == 2) {
    return "(" . getRegex($entry[0]) . getRegex($entry[1]) . ")";
  } else if (count($entry) == 3) {
    return "(" . getRegex($entry[0]) . "|" . getRegex($entry[2]) . ")";
  } else {
    return "(" . getRegex($entry[0]) . getRegex($entry[1]) . "|" . getRegex($entry[3]) . getRegex($entry[4]) . ")";
  }
}

$regex = "";
$count = 0;
while (($line = trim(fgets($handle))) !== false) {
  if (!$line) {
    $stage++;
    if ($stage == 1) {
      $regex = getRegex("0");
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