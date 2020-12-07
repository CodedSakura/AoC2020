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

    fun getInstances(name: String): Set<String> {
        val s = mutableSetOf<String>()
        bags.filter { it.second.containsKey(name) } .forEach {
            s.add(it.first)
            s.addAll(getInstances(it.first))
        }
        return s
    }

    println(getInstances("shiny gold").size)
}