import matplotlib.pyplot as plt #pip install matplotlib
import string
alice = open('./alice_in_wonderland.txt', 'r').read()

D = dict.fromkeys(string.ascii_lowercase)

plt.bar(range(len(D)), list(D.values()), align='center')
plt.xticks(range(len(D)), list(D.keys()))
print(D)
#plt.show()