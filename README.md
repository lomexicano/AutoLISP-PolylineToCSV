# AutoLISP Polyline to CSV Exporter

A lightweight and efficient AutoLISP script for AutoCAD that exports the vertices (coordinates) of selected polylines to a CSV or text file. 

It is specifically designed to handle common data-exporting headaches by allowing easy customization of decimal and column separators, and it includes a smart algorithm to automatically omit the Z-axis if your drawing is strictly 2D. This is especially useful because AutoCAD's native Data Extraction feature does not allow exporting polyline vertex coordinates, even though other properties are available.

## ✨ Features

* **Quick Export:** Select multiple polylines and export all their vertices in one go.
* **Smart Z-Axis Detection:** Automatically checks if all points lie on the XY plane (Z=0). If true, it exports only X and Y columns to keep your data clean. (This can be turned off).
* **Custom Separators:** Easily edit the script to change the column separator (Tab, Semicolon, Comma) and the decimal separator (Dot or Comma) to match your region's Excel/software standards.
* **Performance Optimized:** The Z-axis check uses an early-exit loop, meaning it won't freeze your AutoCAD even if you select a polyline with tens of thousands of vertices.

## 🚀 How to Use

1. Download the `ExportPolyToCSV.lsp` file.
2. Open AutoCAD and type the command `APPLOAD`.
3. Locate and load the downloaded `.lsp` file.
4. Type the command `ExportPolyToCSV` in the AutoCAD command line and press Enter.
5. Select the polylines you want to export.
6. Choose the destination folder and name your CSV file.

## ⚙️ Configuration

You can easily tweak the script to match your workflow by opening the `.lsp` file in any text editor (like Notepad, Sublime Text, VSCode) and changing the variables at the top of the code:

```lisp
;; ==========================================
;; QUICK EDIT VARIABLES
;; ==========================================
(setq colSep "\t") ; Column Separator (e.g., "\t", ";", or ",")
(setq decSep ".")  ; Decimal Separator  (e.g., "." or ",")

;; Set to T (True) to omit the Z column if ALL points have Z=0. 
;; Set to nil (False) to always export Z, even if it is 0.
(setq omitZeroZ T) 
;; ==========================================
```

## 📄 License
This project is open-source and available under the MIT License. Feel free to fork, modify, and use it in your own projects.
