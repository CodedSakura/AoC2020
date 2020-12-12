(defun rotate (facing arg)
  (if (string= (first arg) "R")
      (string (char "NESWNESW" (+ (search facing "NESW") (/ (second arg) 90))))
      (string (char "NWSENWSE" (+ (search facing "NWSE") (/ (second arg) 90))))))

(defun movVec (dir)
  (list (- (or (search dir "S N") 1) 1) (- (or (search dir "W E") 1) 1)))

(defvar *data*
  (mapcar
    (lambda(x) (list (string (char x 0)) (parse-integer (subseq x 1))))
    (uiop:read-file-lines "input.txt")))

(defvar x 0)
(defvar y 0)
(defvar facing 0)

(setq x 0 y 0 facing "E")
(dolist (op *data*)
  (if (search (first op) "LR")
      (setq facing (rotate facing op))
      (if (string= (first op) "F")
	  (let ((mv (movVec facing)))
	     (setq x (+ x (* (second op) (first mv))) y (+ y (* (second op) (second mv)))))
	  (let ((mv (movVec (first op))))
	    (setq x (+ x (* (second op) (first mv))) y (+ y (* (second op) (second mv))))))))
(print (+ (abs x) (abs y)))
