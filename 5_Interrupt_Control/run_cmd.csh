clear
rm -rf INCA_libs/ irun* waves.shm/ cov_work/
clear
irun -access +rwc -f compile.f -uvmhome CDNS-1.1d  +UVM_TESTNAME=ic_rst_test 		-coverage all -covoverwrite -seed random
irun -access +rwc -f compile.f -uvmhome CDNS-1.1d  +UVM_TESTNAME=ic_mmr_read_test 	-coverage all -covoverwrite
irun -access +rwc -f compile.f -uvmhome CDNS-1.1d  +UVM_TESTNAME=ic_mmr_write_test 	-coverage all -covoverwrite
irun -access +rwc -f compile.f -uvmhome CDNS-1.1d  +UVM_TESTNAME=ic_mmr_rd_wr_rd_test 	-coverage all -covoverwrite
irun -access +rwc -f compile.f -uvmhome CDNS-1.1d  +UVM_TESTNAME=ic_config_test 	-coverage all -covoverwrite
irun -access +rwc -f compile.f -uvmhome CDNS-1.1d  +UVM_TESTNAME=ic_single_int_test 	-coverage all -covoverwrite
irun -access +rwc -f compile.f -uvmhome CDNS-1.1d  +UVM_TESTNAME=ic_multi_int_test 	-coverage all -covoverwrite
irun -access +rwc -f compile.f -uvmhome CDNS-1.1d  +UVM_TESTNAME=ic_cont_int_test 	-coverage all -covoverwrite
irun -access +rwc -f compile.f -uvmhome CDNS-1.1d  +UVM_TESTNAME=ic_preempt_test	-coverage all -covoverwrite
irun -access +rwc -f compile.f -uvmhome CDNS-1.1d  +UVM_TESTNAME=ic_equal_lvl_diff_pri_test -coverage all -covoverwrite
irun -access +rwc -f compile.f -uvmhome CDNS-1.1d  +UVM_TESTNAME=ic_all_int_test 	-coverage all -covoverwrite
irun -access +rwc -f compile.f -uvmhome CDNS-1.1d  +UVM_TESTNAME=ic_disable_int_test 	-coverage all -covoverwrite
irun -access +rwc -f compile.f -uvmhome CDNS-1.1d  +UVM_TESTNAME=ic_wrong_eoi_id_test 	-coverage all -covoverwrite
irun -access +rwc -f compile.f -uvmhome CDNS-1.1d  +UVM_TESTNAME=ic_random_test 	-coverage all -covoverwrite
imc -exec imc_report.cmd
cd report/
gvim coverage.rpt
cd ..
imc &
simvision waves.shm/ &
#simvision waves.shm/ -input fl2fx_4bit.svcf &

