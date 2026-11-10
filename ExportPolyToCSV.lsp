(defun c:ExportPolyToCSV (/ ss filename f i num vtx pt ent param colSep decSep omitZeroZ format-num has-z export-z x y z)
  (vl-load-com)
  
  ;; ==========================================
  ;; QUICK EDIT VARIABLES
  ;; ==========================================
  (setq colSep "\t") ; Column Separator (e.g., "\t", ";", or ",")
  (setq decSep ".")  ; Decimal Separator  (e.g., "." or ",")
  
  ;; Set to T (True) to omit the Z column if ALL points have Z=0. 
  ;; Set to nil (False) to always export Z, even if it is 0.
  (setq omitZeroZ T) 
  ;; ==========================================

  ;; Helper function to format numbers forcing the chosen decimal separator
  (defun format-num (val sep)
    (vl-string-translate ",." (strcat sep sep) (rtos val 2 4))
  )

  (setq ss (ssget '((0 . "*POLYLINE"))))
  
  (if ss
    (progn
      (setq filename (getfiled "Save CSV File" "" "csv" 1))
      
      (if filename ; Checks if the user didn't cancel the save dialog
        (progn
          
          ;; --- Z-COORDINATE CHECK ---
          (setq has-z nil)
          (if omitZeroZ
            (progn
              (setq i -1)
              ;; Loop through entities. Stops early if has-z becomes T
              (while (and (setq ent (ssname ss (setq i (1+ i)))) (not has-z))
                (setq vtx (vlax-curve-getEndParam ent)
                      param -1)
                ;; Loop through vertices. Stops early if has-z becomes T
                (while (and (< param vtx) (not has-z))
                  (setq param (1+ param))
                  (setq pt (vlax-curve-getPointAtParam ent param))
                  ;; Check if Z is not equal to 0 (using a 1e-6 tolerance for CAD float inaccuracies)
                  (if (not (equal (caddr pt) 0.0 1e-6))
                    (setq has-z T)
                  )
                )
              )
            )
          )
          
          ;; Determine the final flag for Z exportation
          (setq export-z (if omitZeroZ has-z T))
          ;; --------------------------

          (setq f (open filename "w")
                i -1
                num 1)
          
          ;; Write the header based on export-z flag
          (if export-z
            (write-line (strcat "X" colSep "Y" colSep "Z") f)
            (write-line (strcat "X" colSep "Y") f)
          )
          
          ;; Write data
          (while (setq ent (ssname ss (setq i (1+ i))))
            (setq vtx (vlax-curve-getEndParam ent)
                  param -1)
            (while (< param vtx)
              (setq param (1+ param))
              (setq pt (vlax-curve-getPointAtParam ent param))
              
              ;; Apply formatting to X and Y
              (setq x (format-num (car pt) decSep)
                    y (format-num (cadr pt) decSep))
              
              ;; Concatenate everything into ONE string and write to file
              (if export-z
                (progn
                  (setq z (format-num (caddr pt) decSep))
                  (write-line (strcat x colSep y colSep z) f)
                )
                (write-line (strcat x colSep y) f)
              )
              
              (setq num (1+ num))
            )
          )
          (close f)
          (princ (strcat "\nSuccess! Coordinates exported to: " filename))
        )
        (princ "\nOperation canceled by user.")
      )
    )
    (princ "\nNo polyline selected.")
  )
  (princ)
)