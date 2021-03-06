#!/usr/bin/env perl

# This scripts writes an HTML results page and does all the necessary file modifications for making results of the AUGUSTUS training web server application available.

# ID is the random project ID of a grails project
# species-name
# grails-out is the directory where grails places the autoAug output files
# www-out is the directory where results shall be made available to end users (i.e. an apache directory)

use strict;
use warnings;
	
my $usage = "writeResultsPage.pl ID species-name submission_date grails-out www-out AugustusConfigPath AugustusScriptsPath final-flag\n";

if(@ARGV != 8){
	my $nArgs = @ARGV;
	print "Number of args $nArgs\n";
	print $usage;
	exit;
}

## automatically configured variables
my $projectID = $ARGV[0];
my $species = $ARGV[1];
my $submissionDate = $ARGV[2];
my $grailsOut = $ARGV[3];
my $wwwOut = $ARGV[4];
my $AUGUSTUS_CONFIG_PATH = $ARGV[5];
my $svnScripts = $ARGV[6];
my $final = $ARGV[7];

my $projectWebOutDir = $wwwOut."/$projectID";

my $cmdStr;
my $content;

if($final == 0){
	## create the webserver output directory
	`mkdir -p $projectWebOutDir`;
	if (not(-d "$projectWebOutDir")){
		print STDERR "Creating the output directory in for apache failed! Check writing permissions!\n";
		exit;
	}
	## create empty results page
	my $head = $svnScripts."/webserver-results.head";
	my $tail = $svnScripts."/webserver-results.tail";
	$content = "<h1 class=\"csc-firstHeader\">Results for job $projectID</h1>\n";
	$content .= "<div class=\"csc-default divider\"><hr></div>\n";
	$content .= "<p>There are no results available, yet!</p><br>\n";
	$cmdStr = "echo \"$content\" | cat $head - $tail > $projectWebOutDir/index.html";
	`$cmdStr`;
}

if($final == 1){
## create a parameter folder in web-out folder
if($projectID =~ m/^t/){
	print STDOUT "writeResults.pl is called in training mode\nCollecting parameters\n";
	my $projectWebOutParams = $wwwOut."/$projectID/$species";
	`mkdir -p $projectWebOutParams`;
	if (not(-d "$projectWebOutParams")){
		print STDERR "Creating the parameter directory in for apache failed! Check writing permissions!\n";
		exit;
	}

	## copy 'adapted' parameter files to web-out parameter folder

	my $cfgFile = $AUGUSTUS_CONFIG_PATH."/species/$projectID/$projectID"."_parameters.cfg";
	if (not(-e $cfgFile)){
		print STDERR "$cfgFile does not exist! Parameters were not trained for job ID $projectID.\n";
	}else{
		$cmdStr = "cat $cfgFile | perl -pe 's/$projectID/$species/;' > $projectWebOutParams/$species"."_parameters.cfg";
		system "$cmdStr\n";
	}
	if (not(-e $cfgFile)){
		print STDERR "$projectWebOutParams/$species"."_parameters.cfg was not written! Check writing permissions!\n";
	}

	$cfgFile = $AUGUSTUS_CONFIG_PATH."/species/$projectID/$projectID"."_metapars.cfg";
	if (not(-e "$projectWebOutParams/$species"."_parameters.cfg")){
		print STDERR "$cfgFile does not exist!\n";
	}else{
		$cmdStr = "cat $cfgFile | perl -pe 's/$projectID/$species/;' > $projectWebOutParams/$species"."_metapars.cfg";
		system "$cmdStr\n";
	}

	$cfgFile = $AUGUSTUS_CONFIG_PATH."/species/$projectID/$projectID"."_metapars.utr.cfg";
	if (not(-e $cfgFile)){
		print STDERR "$cfgFile does not exist!\n";
	}else{
		$cmdStr = "cat $cfgFile | perl -pe 's/$projectID/$species/;' > $projectWebOutParams/$species"."_metapars.utr.cfg";
		system "$cmdStr\n";
	}

	$cfgFile = $AUGUSTUS_CONFIG_PATH."/species/$projectID/$projectID"."_exon_probs.pbl";
	if (not(-e $cfgFile)){
		print STDERR "$cfgFile does not exist!\n";
	}else{
		$cmdStr = "cat $cfgFile | perl -pe 's/$projectID/$species/;' > $projectWebOutParams/$species"."_exon_probs.pbl";
		system "$cmdStr\n";
	}

	$cfgFile = $AUGUSTUS_CONFIG_PATH."/species/$projectID/$projectID"."_exon_probs.pbl.withoutCRF";
	if (not(-e $cfgFile)){
		print STDERR "$cfgFile does not exist!\n";
	}else{
		$cmdStr = "cat $cfgFile | perl -pe 's/$projectID/$species/;' > $projectWebOutParams/$species"."_exon_probs.pbl.withoutCRF";
		system "$cmdStr\n";
	}

	$cfgFile = $AUGUSTUS_CONFIG_PATH."/species/$projectID/$projectID"."_igenic_probs.pbl";
	if (not(-e $cfgFile)){
		print STDERR "$cfgFile does not exist!\n";
	}else{
		$cmdStr = "cat $cfgFile | perl -pe 's/$projectID/$species/;' > $projectWebOutParams/$species"."_igenic_probs.pbl";
		system "$cmdStr\n";
	}

	$cfgFile = $AUGUSTUS_CONFIG_PATH."/species/$projectID/$projectID"."_igenic_probs.pbl.withoutCRF";
	if (not(-e $cfgFile)){
		print STDERR "$cfgFile does not exist!\n";
	}else{
		$cmdStr = "cat $cfgFile | perl -pe 's/$projectID/$species/;' > $projectWebOutParams/$species"."_igenic_probs.pbl.withoutCRF";
		system "$cmdStr\n";
	}

	$cfgFile = $AUGUSTUS_CONFIG_PATH."/species/$projectID/$projectID"."_intron_probs.pbl";
	if (not(-e $cfgFile)){
		print STDERR "$cfgFile does not exist!\n";
	}else{
		$cmdStr = "cat $cfgFile | perl -pe 's/$projectID/$species/;' > $projectWebOutParams/$species"."_intron_probs.pbl";
		system "$cmdStr\n";
	}

	$cfgFile = $AUGUSTUS_CONFIG_PATH."/species/$projectID/$projectID"."_intron_probs.pbl.withoutCRF";
	if (not(-e $cfgFile)){
		print STDERR "$cfgFile does not exist!\n";
	}else{
		$cmdStr = "cat $cfgFile | perl -pe 's/$projectID/$species/;' > $projectWebOutParams/$species"."_intron_probs.pbl.withoutCRF";
		system "$cmdStr\n";
	}

	$cfgFile = $AUGUSTUS_CONFIG_PATH."/species/$projectID/$projectID"."_weightmatrix.txt";
	if (not(-e $cfgFile)){
		print STDERR "$cfgFile does not exist!\n";
	}else{
		$cmdStr = "cat $cfgFile | perl -pe 's/$projectID/$species/;' > $projectWebOutParams/$species"."_weightmatrix.txt";
		system "$cmdStr\n";
	}

	$cfgFile = $AUGUSTUS_CONFIG_PATH."/species/$projectID/$projectID"."_utr_probs.pbl";
	if (not(-e $cfgFile)){
		print STDOUT "$cfgFile does not exist!\n";
	}else{
		$cmdStr = "cat $cfgFile | perl -pe 's/$projectID/$species/;' > $projectWebOutParams/$species"."_utr_probs.pbl";
		system "$cmdStr\n";
	}

	## pack parameters
	if(-e $AUGUSTUS_CONFIG_PATH."/species/$projectID/$projectID"."_parameters.cfg"){
		print STDOUT "Packing parameters...\n";
		$cmdStr = "cd $projectWebOutDir; tar -czvf parameters.tar.gz $species &> /dev/null;";
		`$cmdStr`;
	}
	if (not(-e "$projectWebOutDir/parameters.tar.gz")){
		print STDERR "$projectWebOutDir/parameters.tar.gz was not packed!\n";
	}

	## remove original parameter directory from apache directory
	if(-d "$projectWebOutDir/$species"){
		print "Cleaning up parameters in apache directory...\n";
		$cmdStr = "rm -r $projectWebOutDir/$species";
		system "$cmdStr\n";
	}

	## copy and pack training gene file
	my $trainingFile = $grailsOut."/$projectID/autoAug/autoAugTrain/training/training.gb";
	print STDOUT "Training file is: $trainingFile\n";
	if (not(-e $trainingFile)){
		print STDERR "$trainingFile does not exist!\n";
		my $cfgFilesDir = "$AUGUSTUS_CONFIG_PATH/species/$projectID/$projectID";
		if(-d $cfgFilesDir){
			`rm -r $cfgFilesDir`;
			print STDERR "Deleting $cfgFilesDir because no relevant parameters can have been produced.\n";
		}
	}else{
		$cmdStr = "cp $trainingFile $projectWebOutDir/training.gb; cd $projectWebOutDir; gzip training.gb &> /dev/null;";
		`$cmdStr`;
	}
	
	if (not(-e $projectWebOutDir."/training.gb.gz")){
		print STDERR "$projectWebOutDir/training.gb.gz was not packed!\n";
	}

	## copy and pack ab-initio output file
	print STDOUT "Packing ab-initio gene predictions...\n";
	my $ab_initio_webDir = $projectWebOutDir."/ab_initio";
	$cmdStr = "mkdir -p $ab_initio_webDir";
	system $cmdStr;
	my $ab_initio_grailsDir = $grailsOut."/$projectID/autoAug/autoAugPred_abinitio";
	if (not(-e "$ab_initio_grailsDir/predictions/augustus.gff")){
		print STDERR "AutoAug did not produce ab initio predictions!\n";
	}else{
		$cmdStr = "cp $ab_initio_grailsDir/predictions/* $ab_initio_webDir; cp $ab_initio_grailsDir/gbrowse/* $ab_initio_webDir;";
		`$cmdStr`;
		$cmdStr = "cd $projectWebOutDir; tar -czvf ab_initio.tar.gz ab_initio;";
		`$cmdStr`;
		$cmdStr = "rm -r $ab_initio_webDir;";
		`$cmdStr`;
	}

	## copy and pack hints predictions - if they exist	
	if(-e $grailsOut."/$projectID/autoAug/autoAugPred_hints/predictions/augustus.gff"){
		print "Packing gene predictions without UTR and with hints...\n";
		my $hintsPred_webDir = $projectWebOutDir."/hints_pred";
		$cmdStr = "mkdir -p $hintsPred_webDir";
		system $cmdStr;
		my $hintsPred_grailsDir = $grailsOut."/$projectID/autoAug/autoAugPred_hints";
		if (not(-d "$hintsPred_grailsDir")){
			print STDERR "AutoAug did not produce hints predictions!\n";
		}
		$cmdStr = "cp $hintsPred_grailsDir/predictions/* $hintsPred_webDir; cp $hintsPred_grailsDir/gbrowse/* $hintsPred_webDir;";
		`$cmdStr`;
		$cmdStr = "cd $projectWebOutDir; tar -czvf hints_pred.tar.gz hints_pred;";
		`$cmdStr`;
		$cmdStr = "rm -r $hintsPred_webDir;";
		`$cmdStr`;	
	}else{
		print STDOUT "AutoAug did not produce predictions with hints (no utr)!\n";
	}

	## copy and pack UTR predictions - if they exist - actually, autoAug NEVER produces this file at the moment!
	if(-e $grailsOut."/$projectID/autoAug/autoAugPred_utr/predictions/augustus.gff"){
		my $utrPred_webDir = $projectWebOutDir."/utr_pred";
		$cmdStr = "mkdir -p$utrPred_webDir";
		system $cmdStr;
		my $utrPred_grailsDir = $grailsOut."/$projectID/autoAug/autoAugPred_utr";
		$cmdStr = "cp $utrPred_grailsDir/predictions/* $utrPred_webDir; cp $utrPred_grailsDir/gbrowse/* $utrPred_webDir;";
		`$cmdStr`;
		$cmdStr = "cd $projectWebOutDir; tar -czvf utr_pred.tar.gz utr_pred;";
		`$cmdStr`;
		$cmdStr = "rm -r $utrPred_webDir;";
		`$cmdStr`;
	}else{
		print STDOUT "AutoAug did not produce utr predictions!\n";
	}	

	## copy and pack UTR hint predictions - if they exist
	if(-e $grailsOut."/$projectID/autoAug/autoAugPred_hints_utr/predictions/augustus.gff"){
		print STDOUT "Packing gene predictions with UTR and hints...\n";
		my $utrHintsPred_webDir = $projectWebOutDir."/hints_utr_pred";
		$cmdStr = "mkdir -p $utrHintsPred_webDir";
		system $cmdStr;
		my $utrHintsPred_grailsDir = $grailsOut."/$projectID/autoAug/autoAugPred_hints_utr";
		$cmdStr = "cp $utrHintsPred_grailsDir/predictions/* $utrHintsPred_webDir; cp $utrHintsPred_grailsDir/gbrowse/* $utrHintsPred_webDir;";
		`$cmdStr`;
		$cmdStr = "cd $projectWebOutDir; tar -czvf hints_utr_pred.tar.gz hints_utr_pred;";
		`$cmdStr`;
		$cmdStr = "rm -r $utrHintsPred_webDir;";
		`$cmdStr`;
	}else{
		print STDOUT "AutoAug did not produce utr and hint predictions!\n";
	}

	## copy log and error file
	my $errorFile = $grailsOut."/$projectID/AutoAug.err";
	my $logFile = $grailsOut."/$projectID/AutoAug.log";
	if(-e $errorFile){
		print STDOUT "Copying error and log file...\n";
		$cmdStr = "cp $errorFile $projectWebOutDir; cp $logFile $projectWebOutDir;";
		`$cmdStr`;
	}else{
		print STDERR "AutoAug.err was not produced!\n";
		exit;
	}
}else{
	## pack and copy augustus predictions
	print STDOUT "writeResults.pl is called in prediction mode...\n";
	if(-d $grailsOut."/$projectID/augustus"){
		print STDOUT "Packing gene predictions...\n";
		$cmdStr = "cd $grailsOut/$projectID; tar -czvf predictions.tar.gz augustus;";
		`$cmdStr`;
		$cmdStr = "cp $grailsOut/$projectID/predictions.tar.gz $projectWebOutDir/predictions.tar.gz";
		`$cmdStr`;
	}
}

## create index.html page
my $head = $svnScripts."/webserver-results.head";
my $tail = $svnScripts."/webserver-results.tail";

if($projectID =~ m/^t/){
	
	$content = "<h1 class=\"csc-firstHeader\">Training results for job $projectID</h1>\n";
	$content .= "<div class=\"csc-default divider\"><hr></div>\n";
	$content .= "<p>On this page, you find all relevant results to AUGUSTUS training run $projectID for species $species, first submitted to our web server application on $submissionDate.</p>\n";
	$content .= "<div class=\"csc-default divider\"><hr></div>\n";
	$content .= "<h2><font color=\"#006699\">Results</font></h2>\n";
	$content .= "<p><b>Log-file</b>&nbsp;&nbsp;<a href=\"AutoAug.log\">AutoAug.log</a></p><br>\n";
	$content .= "<p><b>Error-file</b>&nbsp;&nbsp;<a href=\"AutoAug.err\">AutoAug.err</a></p><br>\n";
	if(-e "$projectWebOutDir/parameters.tar.gz"){
		$content .= "<p><b>Species parameter archive</b>&nbsp;&nbsp;<a href=\"parameters.tar.gz\">parameters.tar.gz</a></p><br>\n";
	}else{
		print STDOUT "Parameters are not included in web output\n";
	}
	if(-e "$projectWebOutDir/training.gb.gz"){
		$content .= "<p><b>Training genes</b>&nbsp;&nbsp;<a href=\"training.gb.gz\">training.gb.gz</a></p><br>\n";
	}else{
		print STDOUT "training.gb is not included in web output\n";
	}
	if(-e "$projectWebOutDir/ab_initio.tar.gz"){
		$content .= "<p><b>Ab initio predictions</b>&nbsp;&nbsp;<a href=\"ab_initio.tar.gz\">ab_initio.tar.gz</a></p><br>\n";
	}else{
		print STDOUT "ab initio predictions are not included in web output\n";
	}
	if(-e "$projectWebOutDir/hints_pred.tar.gz"){
		$content .= "<p><b>Predictions with hints</b>&nbsp;&nbsp;<a href=\"hints_pred.tar.gz\">hints_pred.tar.gz</a></p><br>\n";
	}else{
		print STDOUT "hint predictions are not included in web output\n";
	}
	if(-e "$projectWebOutDir/utr_pred.tar.gz"){
		$content .= "<p><b>Predictions with UTR</b>&nbsp;&nbsp;<a href=\"utr_pred.tar.gz\">utr_pred.tar.gz</a></p><br>\n";
	}else{
		print STDOUT "UTR predictions are not included in web output\n";
	}
	if(-e "$projectWebOutDir/hints_utr_pred.tar.gz"){
		$content .= "<p><b>Predictions with hints and UTR</b>&nbsp;&nbsp;<a href=\"hints_utr_pred.tar.gz\">hints_utr_pred.tar.gz</a></p><br>\n";
	}else{
		print STDOUT "UTR and hint predictions are not included in web output\n";
	}	
	$content .= "<br><br>\n";
}else{
	$content = "<h1 class=\"csc-firstHeader\">Predicting Genes with AUGUSTUS<br>Job $projectID</h1>\n";
	$content .= "<div class=\"csc-default divider\"><hr></div>\n";
	$content .= "<p>On this page, you find all relevant results to AUGUSTUS prediction run $projectID, first submitted to our web server application on $submissionDate.</p>\n";
	$content .= "<div class=\"csc-default divider\"><hr></div>\n";
	$content .= "<h2><font color=\"#006699\">Results</font></h2>\n";
	$content .= "<p><b>Prediction archive</b>&nbsp;&nbsp;<a href=\"predictions.tar.gz\">predictions.tar.gz</a></p><br>\n";
}

$cmdStr = "echo \"$content\" | cat $head - $tail > $projectWebOutDir/index.html";
`$cmdStr`;
}
