class B {
    static void main(String... args) {
        def arr = []
        new File("input.txt").eachLine {
            arr << it.toInteger()
        }
        arr = arr.sort() as List<Integer>
        arr = [0] + arr + [arr.last()+3]
        def last = arr[1] - arr[0]
        def count = 0
        def total = 1G
        for (i in 1..<arr.size()) {
            def v = arr.get(i) - arr.get(i-1)
            if (v == last) {
                count++
            } else {
                if (last == 1) {
                    total *= Math.min(1 << (count - 1), 7)
                }
                last = v
                count = 1
            }
        }
        println(total)
    }
}
