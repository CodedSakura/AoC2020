import java.io.File

fun main() {
    val lines = File("input.txt").bufferedReader().readLines()
    val bags = ArrayList<Pair<String, HashMap<String, Int>>>()
    lines.forEach { line ->
        val a = line.split(" contain ")
        val bag = a[0].replace(" bags", "")
        val cont = HashMap<String, Int>()
        a[1].split(", ").forEach {
            val gv = "(\\d+) (.+) bags?\\.?".toRegex().find(it)?.groupValues
            if (gv != null && gv.size > 2)
                cont[gv[2]] = gv[1].toInt()
        }
        bags.add(Pair(bag, cont))
    }

    fun getContents(name: String): Int {
        val bag = bags.find { it.first == name } ?: return 1
        return bag.second.map {
            getContents(it.key) * it.value
        }.sum() + 1
    }

    println(getContents("shiny gold") - 1) // subtract the gold bag from it's contents
}