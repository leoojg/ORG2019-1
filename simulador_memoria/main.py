## Alunos: Leonardo José e Michel

MM = []
for i in range(128):
	MM.append(0)

CM = []
for i in range(4):
	CM.append(['invalid', 'invalid'])

data = [0, 0, 0, 0]

def menu():
	print('1 - Ler endereço de memória\n2 - Escrever em endereço de memória\n3 - Mostrar estatísticas\n4 - Sair')

def writeMemory(values, address):
	for i in values:
		MM[address] = i
		address+=1

def lru():
	for i in CM:
		for j in i:
			if j == 'invalid':
				continue
			j[1]+= 1

def getFromMemory(block, label, DS):
	memoryBlock = MM[block*4:block*4+4]
	toCache = [label, 0,  memoryBlock]
	if 'invalid' in CM[DS]:
		CM[DS][CM[DS].index('invalid')] = toCache
	else:
		lru = []
		lruMax = 0;
		for i in CM[DS]:
			if i[1] > lruMax:
				lru = i
				lruMax = i[1]
		writeMemory(lru[2], block*4)
		CM[DS][CM[DS].index(lru)] = toCache

def addStatistics(bool, type):
	if type:
		if bool:
			data[0]+=1
		data[1]+=1
	else:
		if bool:
			data[2]+=1
		data[3]+=1

def isInCache(address, write):
	if int(address, 2) > 127 or int(address, 2) < 0:
		print('Insira um endereço valido!')
		return
	block = (int(address, 2)//4)
	DS = block%4
	label = int(address[:4], 2)
	offset = int(address[5:], 2)
	lru()
	inCache = False
	for i in CM[DS]:
		if i == 'invalid':
			continue
		if label in i:
			inCache = True
	if not inCache:
		getFromMemory(block, label, DS)
		print('Endereço não encontrado na cache! Bloco: ' + str(block) + ' Rótulo: ' + str(label) + ' Offset: ' + str(offset))
		addStatistics(False, write)
	else:
		print('Endereço na cache! Bloco: ' + str(block) + ' Rótulo: ' + str(label) + ' Offset: ' + str(offset))
		addStatistics(True, write)
	if write:
		print('Digite o que deseja guardar na memória: ',end='')
		for i in CM[DS]:
			if label == i[0]:
				i[2][offset] = input()

while True:
	print(CM)
	menu()
	user = int(input())
	if user == 1:
		print('Escolha o endereço para ler da memória')
		isInCache(input(), False)
		
	elif user == 2:
		print('Escolha em qual endereço quer escrever')
		isInCache(input(), True)

	elif user == 3:
		if(data[1] == 0 or data[3] == 0):
			print('Precisa realizar uma operação de cada ao menos\n\n')
			continue
		aE = data[0]
		tE = data[1]
		aL = data[2]
		tL = data[3]
		print('Leitura:')
		print('Acertos totais: ' + str(aL) + ' percentual de ' + str() + '%')
		print('Erros totais: ' + str(tL-aL) + ' percentual de ' + str((tL-aL)//tL*100) + '%')
		print('Escrita:')
		print('Acertos totais: ' + str(aE) + ' percentual de ' + str(aE//tE*100) + '%')
		print('Erros totais: ' + str(tE-aE) + ' percentual de ' + str((tE-aE)//tE*100) + '%')
		print('Geral:')
		print('Acertos totais: ' + str(aE+aL) + ' percentual de ' + str((aE+aL)//(tE+tL)*100) + '%')
		print('Erros totais: ' + str(tE-aE + tL-aL) + ' percentual de ' + str((tE-aE + tL-aL)//(tE+tL)*100) + '%')
	elif user == 4:
		break
	else:
		print('Escolha uma opcao valida')