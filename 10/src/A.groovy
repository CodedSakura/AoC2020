class A {
    static void main(String... args) {
        def arr = []
        new File("input.txt").eachLine {
            arr << it.toInteger()
        }
        arr = arr.sort() as List<Integer>
        arr = [0] + arr + [arr.last()+3]
        def counter = [0, 0, 0]
        for (i in 1..<arr.size()) {
            counter[arr.get(i) - arr.get(i-1) - 1]++
        }
        println(counter[0] * counter[2])
    }
}
