#!/usr/bin/perl

# Chopstick Task Log Processing Script
#
# Original Author: Maike Hille 
# Modified by: Deniz Lal Ersoy
# Email: ersoydenizlal@gmail.com
# Date: 2023-04-02
#
# Description:
# This script extracts onset times from log files generated during the chopstick task.
# It converts the log format into a tabular text output.
#
# Usage:
# perl chopstick_onsettimes.pl logfile (name without extension)
#
# Input: logfile.log (must be specified as an argument)
# Output: logfile.txt (converted onset times in tabular format)

use strict;
use warnings;

# Get logfile name from command-line argument
my ($logfile) = @ARGV;

# Check if logfile argument is provided
if (!$logfile) {
    print "Usage: perl chopstick_onsettimes.pl logfile (without extension)\n";
    exit;
}

# Define input and output file names
my $inlogf = "$logfile.log";
my $out2 = "$logfile.txt";

# Open output file
open(my $OUT, '>', $out2) or die "Error: Cannot open output file $out2\n";

# Open input log file
open(my $INPUT, '<', $inlogf) or die "Error: Cannot open log file $inlogf\n";

# Skip lines until reaching 'Trial' marker
while (<$INPUT>) {
    chomp;
    my @elem = split;
    last if /Trial/;
}

# Initialize variables
my $Zaehler = 0;
my $first_pulse;

# Process log file line by line
while (<$INPUT>) {
    chomp;
    my ($Subject, $Trial, $Event, $Code, $Time, $TTime, $Uncertainty, $Duration) = split;

    # Detect first pulse and adjust time reference
    if (($Event eq "Pulse") && ($Code eq "99") && ($Trial == 1)) {
        $first_pulse = $Time - 80000;  # Adjust based on TR & experiment specifics
    }

    # Detect stimulus onset times
    if (($Event eq "Picture") && (($Code =~ /chopstick/) || ($Code =~ /hand/))) {
        my $Onset_pic = $Time;
        my $Onset_pic_corrected = $Time - $first_pulse;
        my $duration_pic = $Duration;
    }

    # Detect end of trial conditions
    if (($Event eq "Picture") && ($Code =~ /Condition_/)) {
        $Zaehler++;
        my @temp2 = split('_', $Code);
        my $cond = $temp2[1];

        # Write formatted output
        print $OUT sprintf("%03d %s %d %d %d %d\n", $Zaehler, $cond, $first_pulse, $Onset_pic, $Onset_pic_corrected, $duration_pic);
    }
}

# Close files
close $INPUT;
close $OUT;

print "Processing complete. Output saved to $out2\n";