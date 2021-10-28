# Proyecto_2_VFCI
Ejecutar en una terminal usando la siguiente línea de comando:vcs -Mupdate testbench.sv -o salida -full64 -sverilog -timescale=1ns/1ps -debug_acc+all -debug_region+encrypt -l log_test +lint=TFIPC-L

Para cambiar la profundidad de las FIFOs manualmente se debe hacer en el archivo testbench.sv en los apartados de las lineas 16 y 19 donde aparece un 4 como profundidad o "depth", por sus siglas en inglés.
