import os
import re


def main():
	results_dict = {}
	for filename in os.listdir('.'):
		if filename.endswith(".txt"): 
			results_dict[filename] = {}
			with open(filename) as f:
				text = f.read()
				for line in text.split('\n'):
					if line == "":
						continue
					m = re.match("mAP (.*): (.*)", line)
					results_dict[filename][m.group(1)] = m.group(2)
	print(results_dict)

if __name__ == "__main__":
	main()