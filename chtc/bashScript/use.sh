#!/bin/bash

mkdir -p log
mkdir -p output
mkdir -p error

condor_submit getKdata/sub

condor_submit_dag A.dag

condor_submit_dag B.dag