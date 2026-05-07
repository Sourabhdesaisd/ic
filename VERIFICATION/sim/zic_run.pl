use strict;
use FileHandle;
use Cwd qw(cwd);
use File::Path;
use List::Util qw(shuffle);

my $simulateFlag  = 1;

my ($day,$mon) = (localtime)[3..5];
my $date = sprintf("%02d_%02d",$day,$mon+1);
my $pwd = cwd;
my $outdir = "$pwd/${date}_report";
system("figlet -c Project-Z");
my $test = $ARGV[0];
my $case = $ARGV[1];
my @pass_tests = ();
my @fail_tests = ();
my $in_count = 0;
my $out_count = 0;
system("mkdir ../ZIC_RTL");
system("cp ../../RTL_SOURCE_FILES/* ../ZIC_RTL");

if($simulateFlag) {
    simulate_test();
}

sub simulate_test 
 {
  my $pass = 0;
  my $seed = int (rand(100000));
  if(defined $case)
  {
    system("xrun -access +rwc -f ../UVME/zic_comp_file.f -svseed $seed +UVM_TESTNAME=$test +TEST_CASE=$case  +define+UVM_REPORT_DISABLE_FILE_LINE -coverage all -covdut zilla_interrupt_control -covworkdir /cov_work -covoverwrite -covfile ./cov_files/cov_cmd.cf -uvmhome CDNS-1.1d"); 
  }
  else
  {
      system("xrun -access +rwc -f ../UVME/zic_comp_file.f -svseed $seed +UVM_TESTNAME=$test +TEST_CASE=$case  +define+UVM_REPORT_DISABLE_FILE_LINE -uvmhome CDNS-1.1d");
  }
  if(open(FILE, "<", "xrun.log")) 
  {
    my $f = do {local $/;<FILE>};
    $pass = ($f =~ /UVM_ERROR\s*:\s*0\s*.*UVM_FATAL\s*:\s*0\s*/);
    my $simdir = "${outdir}/${test}_${seed}";
    mkpath($simdir) unless (-d $simdir);
    if(open (FILE1,'>',"${simdir}/${test}_${seed}.log"))
    {   
        print FILE1 $f;
    }
    close (FILE1);  
     
    system("mv ./wave.shm ${simdir}/");

  }
  open(FILE2, ">>", "${outdir}/${date}_report.log") or die $!;
  if($pass)
  {
    if(defined $case)
    {
     print FILE2 "test_name:${test}  case :${case}  seed:${seed}  status:PASS\n";
    }
    else
    {
     print FILE2 "test_name:${test}  case :ALL  seed:${seed}  status:PASS\n"; 
    }
  }
  else {
    if(defined $case)
    {
     print FILE2 "test_name : ${test}     case : ${case}     seed : ${seed}     status : FAIL\n";
    }
    else
    {
     print FILE2 "test_name : ${test}     case : ALL     seed : ${seed}     status : FAIL\n";
    }
    
  }
  close(FILE2);
  print "\n";
  system("cat ${outdir}/${date}_report.log");
  close (FILE);
}              

system("rm -rf x*");
system("rm -r ../ZIC_RTL");
system("rm -r cov_work");

  exit 0;                         

