#!/bin/bash

TOWER_ROOT=tower-src
set -x
mkdir -p circuits circuits/qc

for i in {1..10}
do
./tower -c --optimize_lir --word_size 2 --mem_size 4 --dotQC -b length:$i $TOWER_ROOT/tests/list.twr length_simplified.twr > circuits/qc/length_simplified$i.qc
./tower -c --optimize_lir --disable_with_do --word_size 2 --mem_size 4 --dotQC -b length:$i $TOWER_ROOT/tests/list.twr length_simplified.twr > circuits/qc/length_simplified_only_cf$i.qc
./tower -c --optimize_lir --disable_nested_if --word_size 2 --mem_size 4 --dotQC -b length:$i $TOWER_ROOT/tests/list.twr length_simplified.twr > circuits/qc/length_simplified_only_cn$i.qc
./tower -c --word_size 2 --mem_size 4 --dotQC -b length:$i $TOWER_ROOT/tests/list.twr length_simplified.twr > circuits/qc/length_simplified_orig$i.qc

./tower -c --optimize_lir --dotQC -b length:$i $TOWER_ROOT/tests/list.twr $TOWER_ROOT/tests/length.twr > circuits/qc/length$i.qc
./tower -c --dotQC -b length:$i $TOWER_ROOT/tests/list.twr $TOWER_ROOT/tests/length.twr > circuits/qc/length_orig$i.qc

./tower -c --optimize_lir --dotQC -b sum:$i $TOWER_ROOT/tests/list.twr $TOWER_ROOT/tests/sum.twr > circuits/qc/sum$i.qc 2> circuits/sum$i.log
./tower -c --dotQC -b sum:$i $TOWER_ROOT/tests/list.twr $TOWER_ROOT/tests/sum.twr > circuits/qc/sum_orig$i.qc 2> circuits/sum_orig$i.log

./tower -c --optimize_lir --dotQC -b find_pos:$i $TOWER_ROOT/tests/list.twr $TOWER_ROOT/tests/find_pos.twr > circuits/qc/find_pos$i.qc 2> circuits/find_pos$i.log
./tower -c --dotQC -b find_pos:$i $TOWER_ROOT/tests/list.twr $TOWER_ROOT/tests/find_pos.twr > circuits/qc/find_pos_orig$i.qc 2> circuits/find_pos_orig$i.log

./tower -c --optimize_lir --dotQC -b remove:$i $TOWER_ROOT/tests/list.twr $TOWER_ROOT/tests/remove.twr > circuits/qc/remove$i.qc 2> circuits/remove$i.log
./tower -c --dotQC -b remove:$i $TOWER_ROOT/tests/list.twr $TOWER_ROOT/tests/remove.twr > circuits/qc/remove_orig$i.qc 2> circuits/remove_orig$i.log

./tower -c --optimize_lir --dotQC -b push_back:$i $TOWER_ROOT/tests/list.twr $TOWER_ROOT/tests/queue.twr > circuits/qc/push_back$i.qc 2> circuits/push_back$i.log
./tower -c --dotQC -b push_back:$i $TOWER_ROOT/tests/list.twr $TOWER_ROOT/tests/queue.twr > circuits/qc/push_back_orig$i.qc 2> circuits/push_back_orig$i.log

./tower -c --optimize_lir --dotQC -b pop_front:$i $TOWER_ROOT/tests/list.twr $TOWER_ROOT/tests/queue.twr > circuits/qc/pop_front$i.qc 2> circuits/pop_front$i.log
./tower -c --dotQC -b pop_front:$i $TOWER_ROOT/tests/list.twr $TOWER_ROOT/tests/queue.twr > circuits/qc/pop_front_orig$i.qc 2> circuits/pop_front_orig$i.log

./tower -c --optimize_lir --dotQC -b is_prefix:$i $TOWER_ROOT/tests/word.twr $TOWER_ROOT/tests/string_word.twr > circuits/qc/is_prefix$i.qc 2> circuits/is_prefix$i.log
./tower -c --dotQC -b is_prefix:$i $TOWER_ROOT/tests/word.twr $TOWER_ROOT/tests/string_word.twr > circuits/qc/is_prefix_orig$i.qc 2> circuits/is_prefix_orig$i.log

./tower -c --optimize_lir --dotQC -b num_matching:$i $TOWER_ROOT/tests/word.twr $TOWER_ROOT/tests/string_word.twr > circuits/qc/num_matching$i.qc 2> circuits/num_matching$i.log
./tower -c --dotQC -b num_matching:$i $TOWER_ROOT/tests/word.twr $TOWER_ROOT/tests/string_word.twr > circuits/qc/num_matching_orig$i.qc 2> circuits/num_matching_orig$i.log

./tower -c --optimize_lir --dotQC -b compare:$i $TOWER_ROOT/tests/word.twr $TOWER_ROOT/tests/string_word.twr > circuits/qc/compare$i.qc 2> circuits/compare$i.log
./tower -c --dotQC -b compare:$i $TOWER_ROOT/tests/word.twr $TOWER_ROOT/tests/string_word.twr > circuits/qc/compare_orig$i.qc 2> circuits/compare_orig$i.log
done

for i in {1..10}
do
./tower -c --optimize_lir --dotQC -b insert:$i $TOWER_ROOT/tests/word.twr $TOWER_ROOT/tests/string_word.twr $TOWER_ROOT/tests/radix_tree.twr > circuits/qc/insert$i.qc 2> circuits/insert$i.log
./tower -c --dotQC -b insert:$i $TOWER_ROOT/tests/word.twr $TOWER_ROOT/tests/string_word.twr $TOWER_ROOT/tests/radix_tree.twr > circuits/qc/insert_orig$i.qc 2> circuits/insert_orig$i.log

./tower -c --optimize_lir --dotQC -b contains:$i $TOWER_ROOT/tests/word.twr $TOWER_ROOT/tests/string_word.twr $TOWER_ROOT/tests/radix_tree.twr > circuits/qc/contains$i.qc 2> circuits/contains$i.log
./tower -c --dotQC -b contains:$i $TOWER_ROOT/tests/word.twr $TOWER_ROOT/tests/string_word.twr $TOWER_ROOT/tests/radix_tree.twr > circuits/qc/contains_orig$i.qc 2> circuits/contains_orig$i.log
done
