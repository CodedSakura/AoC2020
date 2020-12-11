(ns A
  (:require [clojure.string :as str]))
(use 'clojure.java.io)

(def lines
  (mapv vec (mapv seq (str/split-lines (slurp "input.txt")))))
(def size {:w (count (lines 0)), :h (count lines)})

(defn countNeighbours [data x y]
  (frequencies (for [_y (range (max 0 (- y 1)) (min (size :h) (+ y 2)))
                 _x (range (max 0 (- x 1)) (min (size :w) (+ x 2)))
                 :when (or (not= _x x) (not= _y y))]
                 (get (get data _y) _x))))

(defn -main []
  (loop [lastData nil currData lines]
    (if (and (= lastData currData))
      (println (get (frequencies (flatten currData)) \#))
      (recur currData (vec (doall (map-indexed (fn [y, row] (vec (doall (map-indexed (fn [x, val]
              (if (= val \.) \.                               ; floor remains as floor
                (let [nb (countNeighbours currData x y)] (if (= val \L)
                  (if (= 0 (get nb \# 0)) \# \L)             ; if free (L), check if 0 occupied (#)? # : L
                  (if (<= 4 (get nb \# 0)) \L \#)            ; if occupied (#), check if >= 4 occupied (#)? L : #
                  )))) row)))) currData)))))))