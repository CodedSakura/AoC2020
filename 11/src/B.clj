(ns B
  (:require [clojure.string :as str]))
(use 'clojure.java.io)

(def lines
  (mapv vec (mapv seq (str/split-lines (slurp "input.txt")))))
(def size {:w (count (lines 0)), :h (count lines)})

(def directions (for [y (range -1 2) x (range -1 2) :when (not= y x 0)] [x, y]))

(defn isOutside
  [x y] (or (< x 0) (< y 0) (>= x (size :w)) (>= y (size :h))))

(defn getData
  ([data x y] (get (get data y) x))
  ([data pos] (get (get data (second pos)) (first pos))))

(defn countNeighbours
  [data inX inY]
    (reduce + (for [dir directions]
        (loop [pos (map + dir [inX, inY])]
          (if (isOutside (first pos) (second pos)) 0        ; if outside of grid, we haven't found an occupied seat
            (if (= (getData data pos) \.)
              (recur (map + pos dir))                       ; if floor, keep searching
              (if (= (getData data pos) \L) 0 1)))))))

(defn -main []
  (loop [lastData nil currData lines]
    (if (and (= lastData currData))
      (println (get (frequencies (flatten currData)) \#))
      (recur currData (vec (doall (map-indexed (fn [y, row] (vec (doall (map-indexed (fn [x, val]
              (if (= val \.) \.                             ; floor remains as floor
                (let [nb (countNeighbours currData x y)] (if (= val \L)
                  (if (= 0 nb) \# \L)                       ; if free (L), check if 0 occupied (#)? # : L
                  (if (<= 5 nb) \L \#)                      ; if occupied (#), check if >= 4 occupied (#)? L : #
                  )))) row)))) currData)))))))