#!/bin/bash
# ---------------------------------------------------------------------
# Copyright (c) 2023 Wagomu project.
#
# This program and the accompanying materials are made available to you under
# the terms of the Eclipse Public License 1.0 which accompanies this
# distribution,
# and is available at https://www.eclipse.org/legal/epl-v20.html
#
# SPDX-License-Identifier: EPL-2.0
# ---------------------------------------------------------------------
CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
longuuid=$(cat /proc/sys/kernel/random/uuid)
uuid=${longuuid:0:8}

#Needs the Path to runSimulations.sh from https://github.com/ProjectWagomu/MalleableJobScheduling
runSimulations="${CWD}/runSimulations.sh"
tmpScript="${CWD}/runExperimentsPECS23-${uuid}.sh"
cp $runSimulations $tmpScript

sed -i "s|^days_to_simulate.*|days_to_simulate=30|g;
       s|^seeds=.*|seeds=(\"S0\" \"S1\" \"S2\" \"S3\" \"S4\" \"S5\" \"S6\" \"S7\" \"S8\" \"S9\")|g;
       s|^malleable_dividation_amount=.*|malleable_dividation_amount=1000|g;
       s|^dividation_split_time=.*|dividation_split_time=60|g;
       s|^application_model=.*|application_model=\"data\/input\/application_model.json\"|g;
       s|^type_probabilities=.*|type_probabilities=(\"100,0,0\" \"90,0,10\" \"80,0,20\" \"70,0,30\" \"60,0,40\" \"50,0,50\" \"40,0,60\" \"30,0,70\" \"20,0,80\" \"10,0,90\" \"0,0,100\")|g;
       s|^min_node_efficiency_threshold=.*|min_node_efficiency_threshold=0.95|g;
       s|^pref_node_efficiency_threshold=.*|pref_node_efficiency_threshold=0.8|g;
       s|^max_node_efficiency_threshold=.*|max_node_efficiency_threshold=0.5|g;
       s|^scaling_formula=.*|scaling_formula=\"(1\/((1-parallel_percentage)+parallel_percentage\/num_nodes))\"|g;
       s|^total_time=.*|total_time=\"60*60*24*\$days_to_simulate\"|g;
       s|^flop_ranges=.*|flop_ranges=\"5E12,4E17\"|g;
       s|^node_ranges=.*|node_ranges=\"1,128\"|g;
       s|^submit_range=.*|submit_range=1|g;
       s|^num_cluster_nodes=.*|num_cluster_nodes=128|g;
       s|^flops_per_cluster_node=.*|flops_per_cluster_node=1E12|g;
       s|^SCHEDULING_FILES=.*|SCHEDULING_FILES=(\"average_agreement.py\" \"average_common_pool.py\" \"average_steal_agreement.py\" \"min_agreement.py\" \"min_common_pool.py\" \"min_steal_agreement.py\" \"pref_agreement.py\" \"pref_common_pool.py\" \"pref_steal_agreement.py\" \"rigid_backfill.py\" \"rigid_easy_backfill.py\")|g;" ${tmpScript}

$tmpScript -s public4
rm $tmpScript