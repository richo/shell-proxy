readme:
	cat README/1 > README.md
	cat proof_of_concept.rb >> README.md
	cat README/2 >> README.md
	ruby proof_of_concept.rb >> README.md
	cat README/3 >> README.md