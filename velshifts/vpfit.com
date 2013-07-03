printf "f\nil\ncs\n2.e-6 10000.0 2.e-6\nn\n0.004\nb\n0.01\n\n\nfort.13\nn\nn\n\n" | vpfit9.5 > /dev/null
