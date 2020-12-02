import scala.io.Source

object A {
  def main(args: Array[String]): Unit = {
    val source = Source.fromFile("input.txt")
    val pattern = """(\d+)-(\d+) (.): (.*)""".r
    var valid = 0
    for (line <- source.getLines) {
      pattern.findAllIn(line).matchData foreach { m =>
        val start = m.group(1).toInt
        val end = m.group(2).toInt
        val char = m.group(3).charAt(0)
        val data = m.group(4)
        valid += (if (start to end contains data.count(_ == char)) 1 else 0)
      }
    }
    println(valid)
    source.close()
  }
}