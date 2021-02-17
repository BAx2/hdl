NAME=`basename $0`
case "$SIMULATOR" in
	modelsim)
  		# ModelSim flow
  		vlib work
  		vcom ${VHDL_SOURCE} || exit 1
		vlog ${SOURCE} || exit 1
  		vsim "axi_puf_"${NAME} -do "add log /* -r; run -a" -gui || exit 1
		;;
	xsim)
  		# xsim flow
  		xvlog -log ${NAME}_xvlog.log --sourcelibdir . ${SOURCE}  || exit 1
		xvhdl -log ${NAME}_xvhdllog.log ${VHDL_SOURCE}  || exit 1
  		xelab -log ${NAME}_xelab.log -debug all axi_puf_${NAME} 
  		xsim work.axi_puf_${NAME} -R
		;;
	*)
  		#Icarus flow is the default
  		mkdir -p run
  		mkdir -p vcd
  		iverilog -o run/run_${NAME} -I.. ${SOURCE} $1 || exit 1
  		cd vcd
  		../run/run_${NAME}
		;;
esac
