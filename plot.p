      # Gnuplot script file for plotting data in file "force.dat"
      # This file is called   force.p
      set   autoscale                        # scale axes automatically
      unset log                              # remove any log-scaling
      unset label                            # remove any previous labels
      set term pngcairo
      set output "comparison.png"
      set xtic auto                          # set xtics automatically
      set ytic auto                          # set ytics automatically
      set title "Comparison of different I/O access patterns"
      set xlabel "Images count"
      set ylabel "Time spent in I/O"
      #set key 0.01,100
      #set xr [0.0:0.022]
      #set xr [0.0:10.0]
      #set yr [0:1500]
      plot    "cg_2d.version1.f90.out" using 1:2  title 'version1' with linespoints , \
              "cg_2d.version1.str.f90.out" using 1:2  title 'version1.str' with linespoints , \
              "cg_2d.version2.f90.out" using 1:2  title 'version2' with linespoints , \
              "cg_2d.version3.f90.out" using 1:2  title 'version3' with linespoints

