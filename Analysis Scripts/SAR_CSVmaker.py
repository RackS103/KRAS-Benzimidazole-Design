'''
Development and Structure-Activity Relationship (SAR) of Novel Benzimidazole KRAS Inhibitors
ASDRP Fall KRAS Group
Benzimidazole data analysis script
Rac Mukkamala, 12/26/2020
'''

import rdkit.Chem.rdMolDescriptors as Desc
from rdkit import Chem
import csv

rawfile = input("Raw File Name: ")
input = csv.DictReader(open(rawfile, "r", encoding='UTF-8'))
out = open('QSARFallLigands.csv', 'w', encoding='UTF-8')
out.write("Series,SMILES,DockScore,MolWt,logP,NumRings,NumRotBonds,NumHBD,NumHBA\n")

for line in input:
    series = str(line['Series'])
    smiles = str(line['SMILES'])
    score = str(line['BindingScore'])
    try:
        mol = Chem.MolFromSmiles(smiles)
        wt = str(round(Desc.CalcExactMolWt(mol), 4))
        logp = str(round(Desc.CalcCrippenDescriptors(mol)[0], 4))
        rings = str(Desc.CalcNumRings(mol))
        rot = str(Desc.CalcNumRotatableBonds(mol))
        hbd = str(Desc.CalcNumLipinskiHBD(mol))
        hba = str(Desc.CalcNumLipinskiHBA(mol))
        out.write(series+","+smiles+","+score+","+wt+","+logp+","+rings+","+rot+","+hbd+","+hba+"\n")
    except Exception as e:
        print("ERROR: " + series)
        print(getattr(e, "message", repr(e)))
out.close()



