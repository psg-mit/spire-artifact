all:
	rm -f ./tower; dune build && ln -s ./_build/default/src/main.exe ./tower

test:
	dune build src/test && ./_build/default/src/test/test.exe

clean:
	dune clean && rm -f ./tower

check:
	./tower -i tests/list.twr tests/length.twr tests/stack.twr tests/stack_len_tests.twr
	./tower -i --inline tests/list.twr tests/length.twr tests/stack.twr tests/stack_len_tests.twr
	./tower -c --no_circuit --interp_lir tests/list.twr tests/length.twr tests/stack.twr tests/stack_len_tests.twr
	./tower -c --no_prim --interp_circuit tests/list.twr tests/length.twr tests/stack.twr tests/stack_len_tests.twr
	./tower -c --interp_prim tests/list.twr tests/length.twr tests/stack.twr tests/stack_len_tests.twr
	./tower -c --optimize_lir --interp_lir --interp_circuit --interp_prim tests/list.twr tests/length.twr tests/stack.twr tests/stack_len_tests.twr
	./tower -i tests/list.twr tests/length_inefficient.twr tests/stack.twr tests/stack_len_tests.twr
	./tower -i --inline tests/list.twr tests/length_inefficient.twr tests/stack.twr tests/stack_len_tests.twr
	./tower -c --no_circuit --interp_lir tests/list.twr tests/length_inefficient.twr tests/stack.twr tests/stack_len_tests.twr
	./tower -c --no_prim --interp_circuit tests/list.twr tests/length_inefficient.twr tests/stack.twr tests/stack_len_tests.twr
	./tower -c --interp_prim tests/list.twr tests/length_inefficient.twr tests/stack.twr tests/stack_len_tests.twr
	./tower -c --optimize_lir --interp_lir --interp_circuit --interp_prim tests/list.twr tests/length_inefficient.twr tests/stack.twr tests/stack_len_tests.twr
	./tower -i tests/list.twr tests/sum.twr tests/stack.twr tests/sum_tests.twr
	./tower -i --inline tests/list.twr tests/sum.twr tests/stack.twr tests/sum_tests.twr
	./tower -c --no_circuit --interp_lir tests/list.twr tests/sum.twr tests/stack.twr tests/sum_tests.twr
	./tower -c --no_prim --interp_circuit tests/list.twr tests/sum.twr tests/stack.twr tests/sum_tests.twr
	./tower -c --interp_prim tests/list.twr tests/sum.twr tests/stack.twr tests/sum_tests.twr
	./tower -c --optimize_lir --interp_lir --interp_circuit --interp_prim tests/list.twr tests/sum.twr tests/stack.twr tests/sum_tests.twr
	./tower -i tests/list.twr tests/contains.twr tests/stack.twr tests/contains_tests.twr
	./tower -i --inline tests/list.twr tests/contains.twr tests/stack.twr tests/contains_tests.twr
	./tower -c --no_circuit --interp_lir tests/list.twr tests/contains.twr tests/stack.twr tests/contains_tests.twr
	./tower -c --no_prim --interp_circuit tests/list.twr tests/contains.twr tests/stack.twr tests/contains_tests.twr
	./tower -c --interp_prim tests/list.twr tests/contains.twr tests/stack.twr tests/contains_tests.twr
	./tower -c --optimize_lir --interp_lir --interp_circuit --interp_prim tests/list.twr tests/contains.twr tests/stack.twr tests/contains_tests.twr
	./tower -i tests/list.twr tests/stack.twr tests/remove.twr tests/remove_tests.twr
	./tower -i --inline tests/list.twr tests/stack.twr tests/remove.twr tests/remove_tests.twr
	./tower -c --no_circuit --interp_lir tests/list.twr tests/stack.twr tests/remove.twr tests/remove_tests.twr
	./tower -c --no_prim --interp_circuit tests/list.twr tests/stack.twr tests/remove.twr tests/remove_tests.twr
	./tower -c --interp_prim tests/list.twr tests/stack.twr tests/remove.twr tests/remove_tests.twr
	./tower -c --optimize_lir --interp_lir --interp_circuit --interp_prim tests/list.twr tests/stack.twr tests/remove.twr tests/remove_tests.twr
	./tower -i tests/list.twr tests/stack.twr tests/find_pos.twr tests/find_pos_tests.twr
	./tower -i --inline tests/list.twr tests/stack.twr tests/find_pos.twr tests/find_pos_tests.twr
	./tower -c --no_circuit --interp_lir tests/list.twr tests/stack.twr tests/find_pos.twr tests/find_pos_tests.twr
	./tower -c --no_prim --interp_circuit tests/list.twr tests/stack.twr tests/find_pos.twr tests/find_pos_tests.twr
	./tower -c --interp_prim tests/list.twr tests/stack.twr tests/find_pos.twr tests/find_pos_tests.twr
	./tower -c --optimize_lir --interp_lir --interp_circuit --interp_prim tests/list.twr tests/stack.twr tests/find_pos.twr tests/find_pos_tests.twr
	./tower -i tests/list.twr tests/queue.twr tests/queue_tests.twr
	./tower -i --inline tests/list.twr tests/queue.twr tests/queue_tests.twr
	./tower -c --no_circuit --interp_lir tests/list.twr tests/queue.twr tests/queue_tests.twr
	./tower -c --no_prim --interp_circuit tests/list.twr tests/queue.twr tests/queue_tests.twr
	./tower -c --interp_prim tests/list.twr tests/queue.twr tests/queue_tests.twr
	./tower -c --optimize_lir --interp_lir --interp_circuit --interp_prim tests/list.twr tests/queue.twr tests/queue_tests.twr
	./tower -i tests/string.twr tests/string_tests.twr
	./tower -i tests/hash_table.twr tests/hash_table_tests.twr
	./tower -i tests/word.twr tests/word_tests.twr
	./tower -i --inline tests/word.twr tests/word_tests.twr
	./tower -c --no_circuit --interp_lir tests/word.twr tests/word_tests.twr
	./tower -c --no_prim --interp_circuit tests/word.twr tests/word_tests.twr
	./tower -c --interp_prim tests/word.twr tests/word_tests.twr
	./tower -c --optimize_lir --interp_lir --interp_circuit --interp_prim tests/word.twr tests/word_tests.twr
	./tower -i tests/word.twr tests/string_word.twr tests/string_word_tests.twr
	./tower -i --inline tests/word.twr tests/string_word.twr tests/string_word_tests.twr
	./tower -c --no_circuit --interp_lir tests/word.twr tests/string_word.twr tests/string_word_tests.twr
	./tower -c --no_prim --interp_circuit tests/word.twr tests/string_word.twr tests/string_word_tests.twr
	./tower -c --interp_prim tests/word.twr tests/string_word.twr tests/string_word_tests.twr
	./tower -c --optimize_lir --interp_lir --interp_circuit --interp_prim tests/word.twr tests/string_word.twr tests/string_word_tests.twr
	./tower -i tests/word.twr tests/string_word.twr tests/radix_tree.twr tests/radix_tree_tests.twr
	./tower -i --inline tests/word.twr tests/string_word.twr tests/radix_tree.twr tests/radix_tree_tests.twr
	./tower -c --no_circuit --interp_lir tests/word.twr tests/string_word.twr tests/radix_tree.twr tests/radix_tree_tests.twr
	./tower -c --no_prim --interp_circuit --word_size 6 tests/word.twr tests/string_word.twr tests/radix_tree.twr tests/radix_tree_tests.twr
	./tower -c --optimize_lir --interp_lir --interp_circuit --no_prim --word_size 6 tests/word.twr tests/string_word.twr tests/radix_tree.twr tests/radix_tree_tests.twr
# the following take several minutes to execute
#	./tower -c --interp_prim --word_size 6 tests/word.twr tests/string_word.twr tests/radix_tree.twr tests/radix_tree_tests.twr
#	./tower -c --optimize_lir --interp_prim --word_size 6 tests/word.twr tests/string_word.twr tests/radix_tree.twr tests/radix_tree_tests.twr
