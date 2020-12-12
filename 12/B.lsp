(defun movVec (dir)
  (list (- (or (search dir "S N") 1) 1) (- (or (search dir "W E") 1) 1)))

(defvar *data*
  (mapcar
    (lambda(x) (list (string (char x 0)) (parse-integer (subseq x 1))))
    (uiop:read-file-lines "input.txt")))

(defvar x 0)
(defvar y 0)
(defvar wx 10)
(defvar wy 1)
(defvar tmp 0)

(setq x 0 y 0 wx 10 wy 1 tmp 0)
(dolist (op *data*)
  (if (search (first op) "LR")
      (if (= (second op) 180)
          (setq wx (- wx) wy (- wy))          ; LR 180 deg 
          (if (= (second op) 270)
              (if (string= (first op) "L")
                  (setq tmp wx wx    wy   wy (- tmp))      ; L 270 deg
                  (setq tmp wx wx (- wy)  wy    tmp))      ; R 270 deg
              (if (string= (first op) "L")
                  (setq tmp wx wx (- wy)  wy    tmp)       ; L 90 deg
                  (setq tmp wx wx    wy   wy (- tmp)))))   ; R 90 deg
      (if (string= (first op) "F")
          (setq x (+ x (* (second op) wx)) y (+ y (* (second op) wy))) ; F
          (let ((mv (movVec (first op))))                              ; NWSE
	    (setq wx (+ wx (* (second op) (second mv))) wy (+ wy (* (second op) (first mv))))))))
(print (+ (abs x) (abs y)))

(makunbound '*data*)
