import scala.io.Source

object B {
  def main(args: Array[String]): Unit = {
    val source = Source.fromFile("input.txt")
    val pattern = """(\d+)-(\d+) (.): (.*)""".r
    var valid = 0
    for (line <- source.getLines) {
      pattern.findAllIn(line).matchData foreach { m =>
        val pos1 = m.group(1).toInt - 1
        val pos2 = m.group(2).toInt - 1
        val char = m.group(3).charAt(0)
        val data = m.group(4)
        valid += (if (data.charAt(pos1) == char ^ data.charAt(pos2) == char) 1 else 0)
      }
    }
    println(valid)
    source.close()
  }
}