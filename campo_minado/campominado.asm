.data
	initMessage: 		.asciiz "Bem vindo ao campo minado!!\n\n"
	difficultyMessage:	.asciiz "a)5x5   b)7x7   c)9x9\nEscolha entre uma dificuldade acima: "
	difficultyMessageError: .asciiz "\n\n\n\nESCOLHA UMA OPCAO VALIDA!!\n"
	difficultyData:		.space 5			## Utilizado para leitura da dificuldade

.text

	main:							###  Inicio do programa
		li $v0, 4
		la $a0, initMessage
		syscall
		
	difficulty:						## Escolha da dificuldade
		la $a0, difficultyMessage
		syscall
		
		li $v0, 8
		la $a0, difficultyData
		li $a1, 5
		syscall						## Leitura da dificuldade
		
		la $s0, difficultyData
		lb $t1, ($s0)
		la $t0, 'a'
		li $s7, 5
		beq $t0, $t1, check
		

		la $t0, 'b'
		li $s7, 7
		beq $t0, $t1, check

		la $t0, 'c'
		li $s7, 9
		beq $t0, $t1, check

	goBack:
		li $v0, 4
		la $a0, difficultyMessageError
		syscall
		j difficulty								## Volta pra leitura da dificuldade, pois a inserida foi invalida.

	check:
		addi $s0, $s0, 1
		lb $t1, ($s0)
		la $t0, '\n'
		beq $t0, $t1, game
		j goBack

	game:
		

	fim:
		
	## Fim da main
	li $v0, 10
	syscall